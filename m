Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHRRJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:09:19 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:36117 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaHRRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:09:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        linux-pwm@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] PWM changes for rk3288-evb
Date: Mon, 18 Aug 2014 10:09:05 -0700
Message-Id: <1408381749-14156-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable the pwm backlight for the rk3288-evb board.
There were tested by watching the backlight grow from off to max with
the following instructions:

  cd /sys/class/backlight/backlight*/
  for i in $(seq 255); do echo $i > brightness; sleep .01; done

The first patch enables the proper IP.  I think it could land in
Heiko's tree.

The second patch switches PWM cells from 2 to 3 on rk3288.  I think it
could land in Thierry's tree.  With the PWM subsystem as currently
structured, I believe this will break backward compatibility.  However
the rk3288 PWM driver was added so recently (and the rk3288 is so new)
that this seems OK.  In the worst case if someone yells that they are
broken, I believe we could fix this in Linux by saying that if a PWM
driver specifies 3 cells and the DTS definition of the PWM says 2
cells that we'll just pretend that we have no flags.

The 3rd and 4th patches are DTS ones.  They could land in Heiko's tree
after the second patch has landed.  They are based atop his current
WIP 3.18 dts tree.  Note that instantiating the PWM backlight will
cause the system to hang unless Heiko's (clk: rockchip: protect
critical clocks from getting disabled)
<patchwork.kernel.org/patch/4725391> is landed.

There are no compile time or runtime dependencies between these
patches except that patch #3 needs to come before patch #4.  ...and of
course the PWM won't work without all 4 patches.


Doug Anderson (4):
  ARM: rockchip: rk3288: Switch to use the proper PWM IP
  pwm: rockchip: Allow polarity invert on rk3288
  ARM: dts: Add main PWM info to rk3288
  ARM: dts: Enable pwm backlight on rk3288-EVB

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +-
 arch/arm/boot/dts/rk3288-evb.dtsi                  | 53 +++++++++++++++++
 arch/arm/boot/dts/rk3288.dtsi                      | 68 ++++++++++++++++++++++
 arch/arm/mach-rockchip/rockchip.c                  | 19 ++++++
 drivers/pwm/pwm-rockchip.c                         | 32 +++++++++-
 5 files changed, 172 insertions(+), 4 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5


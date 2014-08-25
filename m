Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaHYXEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:04:41 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36596 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaHYXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:04:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        linux-pwm@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 0/3] PWM changes for rk3288-evb
Date: Mon, 25 Aug 2014 15:59:24 -0700
Message-Id: <1409007567-23523-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable the PWM backlight for the rk3288-evb board.
There were tested by watching the backlight grow from off to max with
the following instructions:

  cd /sys/class/backlight/backlight*/
  for i in $(seq 255); do echo $i > brightness; sleep .01; done

The first patch switches PWM cells from 2 to 3 on rk3288.  I think it
could land in Thierry's tree.  This patch will break backward
compatibility for rk3288 until changes land handling PWM cells more
dynamically, but since there are no rk3288 boards shipping yet it
seems OK.

The 2nd and 3rd patches are DTS ones.  They could land in Heiko's tree
after the first two patches.  They are based atop his current WIP 3.18
dts tree.  Note that instantiating the PWM backlight will cause the
system to hang unless Heiko's (clk: rockchip: protect critical clocks
from getting disabled) <patchwork.kernel.org/patch/4725391> is landed.

There are no compile time or runtime dependencies between these
patches except that patch #2 needs to come before patch #3.  ...and of
course the PWM won't work without all 3 patches.

There is a missing patch from this series: the patch that enables the
proper IP in the rk3288 "grf" (general register file).  That patch can
come later.  For now we'll assume that firmware (or some out of tree
kernel patch) will set it up.

Changes in v5:
- Back to version 3 (no rockchip,grf).

Changes in v4:
- Updated comment not to add caveats about pwm_cells 3.
- rockchip_pwm_set_polarity() is now static.
- Separate pwm_ops for v1 and v2; no set_polarity() in v1.
- Added a blank line.
- Add rockchip,grf to pwm nodes.

Changes in v3:
- Don't store a private copy of polarity.
- Use true instead of 1.
- Cleanup init order with "has_invert".
- Fix space to tab in 2 places in DTS.
- Make sure PWM is upper case in prose.

Doug Anderson (3):
  pwm: rockchip: Allow polarity invert on rk3288
  ARM: dts: Add main PWM info to rk3288
  ARM: dts: Enable PWM backlight on rk3288-evb

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +-
 arch/arm/boot/dts/rk3288-evb.dtsi                  | 53 +++++++++++++++++
 arch/arm/boot/dts/rk3288.dtsi                      | 68 ++++++++++++++++++++++
 drivers/pwm/pwm-rockchip.c                         | 57 +++++++++++++++---
 4 files changed, 171 insertions(+), 11 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5


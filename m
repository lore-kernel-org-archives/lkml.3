Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaK0Bas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:30:48 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:61555 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaK0Bap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:30:45 -0500
From: Alexandru M Stan <amstan@chromium.org>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        addy ke <addy.ke@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Alexandru M Stan <amstan@chromium.org>, mark.rutland@arm.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, galak@codeaurora.org,
        mark.yao@rock-chips.com
Subject: [PATCH v4 0/2] Add support for the rockchip mmc clock phases using the framework
Date: Wed, 26 Nov 2014 17:30:25 -0800
Message-Id: <1417051827-12564-1-git-send-email-amstan@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now all I have is the getter and setter for the phase, nothing that uses it
(that is ready). You can test the getter like this:
localhost ~ # cat /sys/kernel/debug/clk/clk_summary|grep sample -C 1
sclk_sdio1                            0            0    24000000          0 0
	sdio1_sample                       0            0    12000000          0 0
	sdio1_drv                          0            0    12000000          0 90
--
	sclk_sdmmc                      1            1   297000000          0 0
		sdmmc_sample                 0            0   148500000          0 134
		sdmmc_drv                    0            0   148500000          0 90
--
	sclk_sdio0                      1            1   100000000          0 0
		sdio0_sample                 0            0    50000000          0 0
		sdio0_drv                    0            0    50000000          0 90
	sclk_emmc                       1            1   100000000          0 0
		emmc_sample                  0            0    50000000          0 0
		emmc_drv                     0            0    50000000          0 180

Next thing that will come is some dts changes that will make use of these new
clocks, and eventually mmc code will be changed to tune with these clocks. You
can see some WIP on https://chromium-review.googlesource.com/#/c/227240


Changes in v4:
- Changed set_phase to 22.5 increments, it seems better for tuning, better at
splitting up big ranges where we might have used an iffy phase from the middle.
- renamed ROCKCHIP_MMC_DELAY_ELEMENT_PSEC
- saner mask of 0x07ff
- only set ROCKCHIP_MMC_DELAYNUM_OFFSET when we need it

Changes in v3:
- renamed everything internal from phase to just mmc_clock or mmc
- added RK3288_MMC_CLKGEN_DIV instead of the magic number
- added new paragraph to commit message

Changes in v2:
- fixed my cc/to list
- removed dangling #DEFINE DEBUG

Alexandru M Stan (2):
  clk: rockchip: add bindings for the mmc clocks
  clk: rockchip: Add support for the mmc clock phases using the
    framework

 drivers/clk/rockchip/Makefile          |   1 +
 drivers/clk/rockchip/clk-mmc-phase.c   | 154 +++++++++++++++++++++++++++++++++
 drivers/clk/rockchip/clk-rk3288.c      |  12 +++
 drivers/clk/rockchip/clk.c             |   8 ++
 drivers/clk/rockchip/clk.h             |  23 +++++
 include/dt-bindings/clock/rk3288-cru.h |  10 +++
 6 files changed, 208 insertions(+)
 create mode 100644 drivers/clk/rockchip/clk-mmc-phase.c

-- 
2.2.0.rc0.207.ga3a616c


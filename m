Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaKOAAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:00:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42684 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaKOAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:00:15 -0500
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
Subject: [PATCH v2 0/2] Add support for the rockchip mmc clock phases using the framework
Date: Fri, 14 Nov 2014 16:00:02 -0800
Message-Id: <1416009604-31545-1-git-send-email-amstan@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
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
clocks, and eventually mmc code will be changed to tune with these clocks.

Changes in v2:
- fixed my cc/to list
- removed dangling #DEFINE DEBUG

Alexandru M Stan (2):
  clk: rockchip: add bindings for the mmc clock phases
  clk: rockchip: Add support for the mmc clock phases using the
    framework

 drivers/clk/rockchip/Makefile          |   1 +
 drivers/clk/rockchip/clk-mmc-phase.c   | 149 +++++++++++++++++++++++++++++++++
 drivers/clk/rockchip/clk-rk3288.c      |  12 +++
 drivers/clk/rockchip/clk.c             |   8 ++
 drivers/clk/rockchip/clk.h             |  23 +++++
 include/dt-bindings/clock/rk3288-cru.h |  10 +++
 6 files changed, 203 insertions(+)
 create mode 100644 drivers/clk/rockchip/clk-mmc-phase.c

-- 
2.1.0.rc2.206.gedb03e5


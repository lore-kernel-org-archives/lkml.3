Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3H1QNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:13:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3H1QNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:13:49 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-73-521e21bbe2b2
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v3 0/6] ARM: S5PV210: move to common clk framework
Date: Wed, 28 Aug 2013 18:12:58 +0200
Message-id: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAd3dinJBBtt7xSwmrTvAZDH/yDlW
	ize9HSwWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2bRs2Erq8WM8/uYLG5f5rW4uE7e4vSa
	U8wWS69fZLJ4OuEim8WE6WtZLA6vAJq27uV0IOtNO6vFq4NtLBbz2l+yWhybsYTRYtWuP4wO
	4h5r5q1h9Ghp7mHzWPD5CrvH68kTGD3+rnrB7LFz1l12j1erZ7J63Lm2h81j85J6j4Pv9jB5
	9G1ZxejxeZOcx8a5oQG8UVw2Kak5mWWpRfp2CVwZDe01BX9FKybMiG1gvCLQxcjJISFgIvFy
	5hpGCFtM4sK99WxdjFwcQgKLGCUmfPjKAuG0M0lcunaaCaSKTcBcYuKzTSwgtoiArMTEyV+Y
	QYqYBW6ySOy40wOWEBZwkvix9SqYzSKgKnH4ZDuQzcHBK+Ar0fSzGmKbgsTPyyfYJjByL2Bk
	WMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHAvPpHcwrmqwOMQowMGoxMMb8Vs2SIg1say4
	MvcQowQHs5II728RuSAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotg
	skwcnFINjHVTVSzKrCRCPolde6fwcffr83cmHCiZ9nmWwr8VD/mqAlcfn2/KpXbwq0qB2pWL
	8pefWPRlbpdOFyzay3lYXOR6n94yYz05gUhx06pcrYlCMnxmdzI6Xp8MnjP53La8iMV57xJu
	2Of39l/LXGSgl31YyGfNNo6AmWe1pktN5hep3sCWv3qavBJLcUaioRZzUXEiAH/Ojm6BAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the new s5pv210 clock implementation
(using common clk framework).

This implementation is compatible with device tree definition and board files.

This patch series is based on linux-next and has been tested on goni and aquila 
boards using board file.

This patch series require adding new registration method
for PLL45xx and PLL46xx, which is included in this patch series:
clk: samsung: pll: Use new registration method for PLL46xx
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg21653.html
clk: samsung: pll: Use new registration method for PLL45xx
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg21652.html
clk: samsung: exynos4: Rename exynos4_plls to exynos4x12_plls
http://www.spinics.net/lists/arm-kernel/msg268486.html

Mateusz Krawczuk (6):
  media: s5p-tv: Replace mxr_ macro by default dev_
  media: s5p-tv: Restore vpll clock rate
  media: s5p-tv: Fix sdo driver to work with CCF
  media: s5p-tv: Fix mixer driver to work with CCF
  clk: samsung: Add clock driver for s5pc110/s5pv210
  ARM: s5pv210: Migrate clock handling to Common Clock Framework

 .../bindings/clock/samsung,s5pv210-clock.txt       |  72 ++
 arch/arm/mach-s5pv210/Kconfig                      |   9 +
 arch/arm/mach-s5pv210/Makefile                     |   4 +-
 arch/arm/mach-s5pv210/common.c                     |  17 +
 arch/arm/mach-s5pv210/common.h                     |  13 +
 arch/arm/mach-s5pv210/mach-aquila.c                |   1 +
 arch/arm/mach-s5pv210/mach-goni.c                  |   3 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   1 +
 arch/arm/mach-s5pv210/mach-torbreck.c              |   1 +
 arch/arm/plat-samsung/Kconfig                      |   2 +-
 arch/arm/plat-samsung/init.c                       |   2 -
 drivers/clk/samsung/Makefile                       |   3 +
 drivers/clk/samsung/clk-s5pv210.c                  | 732 +++++++++++++++++++++
 drivers/media/platform/s5p-tv/mixer.h              |  12 -
 drivers/media/platform/s5p-tv/mixer_drv.c          |  80 ++-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |   6 +-
 drivers/media/platform/s5p-tv/mixer_video.c        | 100 +--
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  45 +-
 include/dt-bindings/clock/samsung,s5pv210-clock.h  | 221 +++++++
 22 files changed, 1216 insertions(+), 113 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

-- 
1.8.1.2


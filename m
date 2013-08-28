Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3H1Nh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:37:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24311 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3H1Nez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:34:55 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-82-521dfc7da441
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
Subject: [PATCH v2 0/5] ARM: S5PV210: move to common clk framework
Date: Wed, 28 Aug 2013 15:34:27 +0200
Message-id: <1377696872-32069-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd3aP7JBBg17+S0mrTvAZDH/yDlW
	ize9HSwWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2bRs2Erq8WM8/uYLG5f5rW4uE7e4vSa
	U8wWS69fZLJ4OuEim8WE6WtZLA6vAJq27uV0IOtNO6vFq4NtLBbz2l+yWhybsYTRYtWuP4wO
	4h5r5q1h9Ghp7mHzWPD5CrvH68kTGD3+rnrB7LFz1l12j1erZ7J63Lm2h81j85J6j4Pv9jB5
	9G1ZxejxeZOcx8a5oQG8UVw2Kak5mWWpRfp2CVwZ0zquMxVMEK74saSBtYFxN18XIyeHhICJ
	xIqLd1khbDGJC/fWs3UxcnEICSxilDh+YisjhNPOJHH43nqwKjYBc4mJzzaxgNgiArISEyd/
	YQYpYha4ySKx404PWEJYwEnix9t7YA0sAqoSZ6fPYQKxeQX8JJZ1vWCDWKcg8fPyCbYJjNwL
	GBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxDPpHYyrGiwOMQpwMCrx8Eb8lg0SYk0s
	K67MPcQowcGsJMLLvx0oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoR
	TJaJg1OqgZHrcIDCohydbu6EWaZPD3Y4pzIv+1srcrOxdIbJp3+Z4dnmi5PY1jcqurE/jLao
	37qCdd37XUsaz03fIm5W6mI/7xZf4d3NLX9t3r5WNzljaHP765Wu28oNc1Uv+D26v9Gkhakm
	/fq7Ni+2xtyei7Mfv/h631Th6/Ify0r5Lup8ZxUtC1k886oSS3FGoqEWc1FxIgCBzcPwhAIA	AA==
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

Mateusz Krawczuk (5):
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
 drivers/clk/samsung/clk-s5pv210.c                  | 733 +++++++++++++++++++++
 drivers/media/platform/s5p-tv/mixer_drv.c          |  35 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  45 +-
 include/dt-bindings/clock/samsung,s5pv210-clock.h  | 221 +++++++
 17 files changed, 1140 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

-- 
1.8.1.2


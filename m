Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3HZLi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:38:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48948 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3HZLiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:38:54 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-40-521b3e4cb881
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH RFC 0/5] ARM: s5pv210: move to common clk framework
Date: Mon, 26 Aug 2013 13:38:29 +0200
Message-id: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQV0fO+kggyU7+S3mHznHavGmt4PF
	onfBVTaLs01v2C02Pb7GarGwbQmLxeVdc9gsZpzfx2Rx+zKvxcV18han15xitnjdd5jFYun1
	i0wWTydcZLOYMH0ti8XhFQeYLNa9nA5kvWlntXh1sI3FYv2M1ywW89pfslocm7GE0WLVrj+M
	DuIea+atYfRoae5h81jw+Qq7x+vJExg9ds66y+7xavVMVo871/aweWxeUu9x8N0eJo++LasY
	Pbo/3WL1+LxJzmPj3NAA3igum5TUnMyy1CJ9uwSujGVnnjMVzBKuaD7dxdjAeJivi5GTQ0LA
	RGLqx6msELaYxIV769m6GLk4hASmM0ps3nGcEcJpZ5KY0nqQHaSKTcBcYuKzTSwgtoiApERT
	wx9mkCJmgRssEguO/gXq4OAQFnCWeL4nFKSGRUBVYtLcM2D1vAJ+Eh2td1kgtilI/Lx8gm0C
	I/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx8Ex6B+OqBotDjAIcjEo8vAFs0kFC
	rIllxZW5hxglOJiVRHjNRYFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YW
	pBbBZJk4OKUaGDOKQqWinTeqxm88LZKUr6S8+dO0K5rvnpdPsryU2yfiOD/AM+HJzFx1G8YP
	ExoXJDsWrd3Uv8hhhtbP4qa425nR65c/Wx52Rcx/++HcL/oyrH/Wr7r8qWGp9vz6SLO81LvH
	f9h+uCzOdrzRXevpJFlzJtdkG9HMBce/3xFi2Lsr9/Re3xdy9UosxRmJhlrMRcWJAOWLf4aD	AgAA
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
  media: s5p-tv: Fix sdo driver to work with CCF
  media: s5p-tv: Fix mixer driver to work with CCF
  ARM: samsung: add clock setup for FIMC and FIMD
  clk: samsung: Add clock driver for s5pc110/s5pv210
  ARM: s5pv210: Migrate clock handling to Common Clock Framework

 .../bindings/clock/samsung,s5pv210-clock.txt       |  72 ++
 arch/arm/mach-s5pv210/Kconfig                      |   9 +
 arch/arm/mach-s5pv210/Makefile                     |   4 +-
 arch/arm/mach-s5pv210/common.c                     |  22 +
 arch/arm/mach-s5pv210/common.h                     |  13 +
 arch/arm/mach-s5pv210/mach-aquila.c                |   1 +
 arch/arm/mach-s5pv210/mach-goni.c                  |  51 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   1 +
 arch/arm/mach-s5pv210/mach-torbreck.c              |   1 +
 arch/arm/plat-samsung/Kconfig                      |   2 +-
 arch/arm/plat-samsung/init.c                       |   2 -
 drivers/clk/samsung/Makefile                       |   3 +-
 drivers/clk/samsung/clk-s5pv210.c                  | 732 +++++++++++++++++++++
 drivers/media/platform/s5p-tv/mixer_drv.c          |  33 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  44 +-
 include/dt-bindings/clock/samsung,s5pv210-clock.h  | 221 +++++++
 17 files changed, 1189 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

-- 
1.8.1.2


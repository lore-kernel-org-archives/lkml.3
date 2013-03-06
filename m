Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3CFK4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:56:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35005 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3CFK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:56:44 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-17-513720ea8ee7
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 0/3] pinctrl: exynos: add support for Samsung's Exynos5250
Date: Wed, 06 Mar 2013 16:48:29 +0530
Message-id: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t9jQd1XCuaBBv//2Vj0LrjKZjHlz3Im
	i02Pr7FaXN41h81ixvl9TBZTDn9hsVg/4zWLA7vHnWt72Dw2L6n36NuyitHj8ya5AJYoLpuU
	1JzMstQifbsEroxbG/YwFezkqHix8h57A+NXti5GTg4JAROJH0d+QNliEhfurQeyuTiEBKYz
	Sqy+MY8dwmljknjfPpkFpIpNwEDi0cJ37CC2iICCxObeZ6wgRcwCKxglTnR9BUsIC/hKLF5x
	nwnEZhFQlejfexfM5hXwlHj78wszxDoliQ29R5kmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREcHM+kdjCubLA4xCjAwajEw2uhZBYoxJpYVlyZe4hRgoNZSYR3q7R5oBBvSmJl
	VWpRfnxRaU5q8SFGaQ4WJXFexlNPAoQE0hNLUrNTUwtSi2CyTBycUg2MaWntlpND361eM4nF
	bYO00+aQsynyginT1ql22vHzXuN7fi3r4Tbzhj1GWnFPIy227T2XKLsroGK3/eR3wvdXp3ke
	SY9q1d49/yhz6sLrrDsPidpNrjF4eupzZMvrbRx7pHR5GJhq6hS2dUt8eiXI4ZP0+KbqHNkP
	rzkMU5f9LOs3nJL5SHGSEktxRqKhFnNRcSIAVRUSBAoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- Change the compatible string from "samsung,pinctrl-exynos5250" to
  "samsung,exynos5250-pinctrl".
- Rebased to v3.9-rc1

This patch series add pinctrl driver support for Samsung's Exynos5250 SoC.
The first patch adds the required Exynos5250 SoC specific data which is
used by the Samsung pinctrl driver to setup the pinctrl/pinmux/eint
controllers. The second and third patches skips the wakeup interrupt and
gpiolib registration if the pinctrl support is enabled for Exynos5250.

Thomas Abraham (3):
  pinctrl: exynos: add exynos5250 SoC specific data
  gpio: samsung: skip gpiolib registration if pinctrl support is enabled for exynos5250
  arm: exynos: skip wakeup interrupt registration for exynos5250 if pinctrl is enabled

 arch/arm/mach-exynos/common.c     |    1 +
 drivers/gpio/gpio-samsung.c       |    1 +
 drivers/pinctrl/pinctrl-exynos.c  |  108 +++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c |    2 +
 drivers/pinctrl/pinctrl-samsung.h |    1 +
 5 files changed, 113 insertions(+), 0 deletions(-)


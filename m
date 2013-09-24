Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3IXQzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:55:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3IXQzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:55:46 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-1e-5241c411f7a1
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: mturquette@linaro.org, t.figa@samsung.com, s.nawrocki@samsung.com,
        yadi.brar@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH 0/3] ARM: S5PC100: move to common clk framework
Date: Tue, 24 Sep 2013 18:55:23 +0200
Message-id: <1380041723-15877-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV3BI45BBkufiVhMWneAyWL+kXOs
	FuderWS0ONv0ht1i0+NrrBaXd81hs5hxfh+Txek1p5gtll6/yGTxdMJFNosJ09eyWBxeAdS2
	7uV0IOtNO6vFq4NtLBbrZ7xmsZgz/R2Tg6DHmnlrGD0WfL7C7vF31Qtmj5XLv7B5vFo9k9Xj
	zrU9bB6bl9R7HHy3h8mjb8sqRo/Pm+Q8Ns4NDeCO4rJJSc3JLEst0rdL4Mq42j6RreATd0XX
	ydWsDYxnOboYOTkkBEwk3r/6wwJhi0lcuLeerYuRi0NIYDqjxK2VS1ggnHYmiWVvfrGCVLEJ
	mEtMfLYJrENEQFZi4uQvzCBFzAJ7mSWmnF0NViQsYC9xa8kzdhCbRUBVYs7uVkYQm1fAT2LF
	/QlMEOsUJH5ePsE2gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgIH4mvYNxVYPF
	IUYBDkYlHt4LCQ5BQqyJZcWVuYcYJTiYlUR4zTc4BgnxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXGAR/8P9nMW6Cs+3Cf56q1/cX+9vfuX9pdozx5QN
	GQ3EFCY/2CzsU3P7ZbRQtHL6koJtlz6fSNLg3miUNXd1Mtf0927Lz3sobXhUb7LNuizbVyjp
	xr1VUyQ/6pyrK2v8P908dNaVt5OucpzPDY6dv+/t2t0bfn6K+7hoEf/pvluW7dsUbmu5pCux
	FGckGmoxFxUnAgDQsbiVXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the new s5pc100 clock implementation
(using common clk framework).

This implementation is compatible with device tree definition and board files.

This patch series is based on linux-next and has been tested on smdkc100 
board using board file.

Mateusz Krawczuk (3):
  clk: samsung: pll: Add support for PLL6545a and PLL6522x
  clk: samsung: Add clock driver for s5pc100
  ARM: s5pc100: Migrate clock handling to Common Clock Framework

 .../bindings/clock/samsung,s5pc100-clock.txt       |  72 +++
 arch/arm/mach-s5pc100/Kconfig                      |   8 +
 arch/arm/mach-s5pc100/Makefile                     |   4 +-
 arch/arm/mach-s5pc100/common.c                     |  23 +-
 arch/arm/mach-s5pc100/common.h                     |  13 +
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   3 +-
 arch/arm/plat-samsung/Kconfig                      |   2 +-
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-pll.c                      |   2 +
 drivers/clk/samsung/clk-pll.h                      |   2 +
 drivers/clk/samsung/clk-s5pc100.c                  | 695 +++++++++++++++++++++
 include/dt-bindings/clock/samsung,s5pc100-clock.h  | 202 ++++++
 12 files changed, 1022 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pc100.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pc100-clock.h

-- 
1.8.1.2


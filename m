Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaIAPUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:20:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35173 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaIAPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:20:47 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2f-54048ecdf095
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clk: qcom: fix driver dependencies
Date: Mon, 01 Sep 2014 17:20:41 +0200
Message-id: <2408462.Vr3YfHniN8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd2zfSwhBt97+S3ONr1ht7i8aw6b
	xdMJF9ksfpzpZnFg8bjc18vkcefaHjaPvi2rGD0+b5ILYInisklJzcksSy3St0vgyljfepGx
	oIet4tn5H4wNjLNYuxg5OSQETCTWv9gBZYtJXLi3nq2LkYtDSGARo8TWjg5mCKeFSeLziuUs
	IFVsAlYSE9tXMYLYIgJaEtsOtLKB2MwCRRJLZv0EmsTBISxgLLG6ORAkzCKgKnHt1BOwEl4B
	TYmPc/rBbFEBT4kd21dCxQUlfky+xwIxRl5i3/6prBC2lsT6nceZJjDyzUJSNgtJ2SwkZQsY
	mVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfjM6kdjCsbLA4xCnAwKvHwPpjFHCLEmlhW
	XJl7iFGCg1lJhDc1gyVEiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA2MFbwzDDHW31R/ELy3codY7zaT7+b3C3ONMUhod1VOf3wmzW3XgTgPHkh6W/KI/
	dh+tFO85r1k66Wrs5aYbFwWu7tgyReK1kO72NMN5F9fzcDPLPJMLOVv+IfR6uM/sqe1rEs+u
	tP78oqevXm5mqJ+lGfP63L5Lz/3EN6lec+JlS73X2jVB7KASS3FGoqEWc1FxIgCCo5+OQgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Qualcomm's clock controllers should be available only on
Qualcomm platforms.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/clk/qcom/Kconfig
===================================================================
--- a/drivers/clk/qcom/Kconfig	2014-08-22 16:53:37.429123415 +0200
+++ b/drivers/clk/qcom/Kconfig	2014-09-01 17:13:43.604778653 +0200
@@ -1,6 +1,7 @@
 config COMMON_CLK_QCOM
 	tristate "Support for Qualcomm's clock controllers"
 	depends on OF
+	depends on ARCH_QCOM || COMPILE_TEST
 	select REGMAP_MMIO
 	select RESET_CONTROLLER
 


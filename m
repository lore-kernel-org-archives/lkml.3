Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3H1FwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:52:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3H1FwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:52:18 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-d1-521d9010d3b2
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 14:52:16 +0900
Message-id: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zI12BCbJBBquv21hsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDJaeruZCy7yVszobmJsYNzM3cXI
	ySEhYCIx7dsRdghbTOLCvfVsXYxcHEICyxglprbtY4Qp+jrzIguILSQwnVHixfNYiKJfjBJP
	t74B62YTUJP48uUwkM3BISLgJXHrThBIDbNAO5PE7xkL2EBqhAWsJa713wCzWQRUJVq2LGAB
	qecVsJU4tdANJMwrICjxY/I9sF3MAloS63ceZ4Kw5SU2r3nLDFIuIaAu8eivLkhYREBP4mzD
	JkaIEhGJfS/eMYKslRD4yC4xres0O8QqAYlvkw+xQPTKSmw6wAzxlqTEwRU3WCYwis1CsnkW
	ks2zkGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxgh0dq/g/HuAetDjMlA6ycy
	S4km5wOjPa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjHtXrV7Gw2S6ws5i6/U3pj7/jpQsEhDbrVDZm+Yickfw9YZlbPuC517VLdLn5njs2jNt
	dcOJYsk8hb8f/W5mXSi+3yTU9iFIoXtjiUS/vqJv5ZPigF/S29f4LGG5Ot9zi1Oeyh6ey0r6
	m/cUbi3jvn3SN5r966QqL48j57Wcprs2z839w/68UImlOCPRUIu5qDgRAH5mupbsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQV2BCbJBBhd3m1tsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmtPR2Mxdc5K2Y0d3E2MC4mbuLkZNDQsBE4uvMiywQtpjEhXvr2UBsIYHpjBIvnsd2MXIB
	2b8YJZ5ufcMOkmATUJP48uUwkM3BISLgJXHrThBIDbNAO5PE7xkLwJqFBawlrvXfALNZBFQl
	WrYsYAGp5xWwlTi10A0kzCsgKPFj8j2wvcwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uSFhE
	QE/ibMMmRogSEYl9L94xTmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMGp4Jn0DsZVDRaHGAU4GJV4eC02ywQJsSaWFVfmHmKU4GBWEuEt+Q8U4k1JrKxK
	LcqPLyrNSS0+xJgM9OdEZinR5HxgmsoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBsZuLuN+WYtHGrv+RDa1pr7Ruxdgsda7tHrpkjtHJy5rUswI3vLp4MaG
	iwe42uuvv33of5HretNa37q0Q4dtzYq4mFb2OAbftxEULTXrd/k+YcW1jXpHV4ln5yQpXFpy
	19vnLmvo69mTLYxvSv5b3fvJc+IUp17DpA1MSmF6zz7+3tgYdXT604NKLMUZiYZazEXFiQCA
	3tffSQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
platform data", .set_pwr() callback is removed from platform data.
Thus, .set_pwr() is not used anymore. Also, this patch fixes
the following build error and warning.

drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in initializer
drivers/mfd/asic3.c:724:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/mfd/asic3.c:724:2: warning: (near initialization for 'asic3_mmc_data.capabilities' [enabled by default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian.molton@collabora.co.uk>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mfd/asic3.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index fa22154..7a6f713 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -705,13 +705,6 @@ static struct mfd_cell asic3_cell_ds1wm = {
 	.resources     = ds1wm_resources,
 };
 
-static void asic3_mmc_pwr(struct platform_device *pdev, int state)
-{
-	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
-
-	tmio_core_mmc_pwr(asic->tmio_cnf, 1 - asic->bus_shift, state);
-}
-
 static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
 {
 	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
@@ -721,7 +714,6 @@ static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
 
 static struct tmio_mmc_data asic3_mmc_data = {
 	.hclk           = 24576000,
-	.set_pwr        = asic3_mmc_pwr,
 	.set_clk_div    = asic3_mmc_clk_div,
 };
 
-- 
1.7.10.4



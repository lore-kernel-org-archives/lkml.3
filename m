Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3JMKQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 06:16:37 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40054 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3JMKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 06:16:35 -0400
Date: Sun, 13 Oct 2013 12:16:30 +0200 (CEST)
From: Roel Kluin <roel.kluin@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: exynos4: index out of bounds if no pixelcode found
Message-ID: <alpine.DEB.2.02.1310131204550.11060@Z>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case no valid pixelcode is found, an i of -1 after the loop is out of 
bounds for the array.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c 
b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 72a343e3b..d0dc7ee 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -133,7 +133,7 @@ void flite_hw_set_source_format(struct fimc_lite *dev, 
struct flite_frame *f)
 	int i = ARRAY_SIZE(src_pixfmt_map);
 	u32 cfg;
 
-	while (--i >= 0) {
+	while (--i) {
 		if (src_pixfmt_map[i][0] == pixelcode)
 			break;
 	}
@@ -240,7 +240,7 @@ static void flite_hw_set_out_order(struct fimc_lite 
*dev, struct flite_frame *f)
 	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
 	int i = ARRAY_SIZE(pixcode);
 
-	while (--i >= 0)
+	while (--i)
 		if (pixcode[i][0] == f->fmt->mbus_code)
 			break;
 	cfg &= ~FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK;


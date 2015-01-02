Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbABUeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:34:09 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37641 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbABUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:34:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: platform: s5p-jpeg: jpeg-hw-exynos4:  Remove some unused functions
Date: Fri,  2 Jan 2015 21:37:07 +0100
Message-Id: <1420231027-2714-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
exynos4_jpeg_set_timer_count() exynos4_jpeg_get_frame_size() exynos4_jpeg_set_sys_int_enable() exynos4_jpeg_get_fifo_status()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |   35 ---------------------
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h |    5 ---
 2 files changed, 40 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
index ab6d6f4..5685577 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
@@ -163,15 +163,6 @@ unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
 	return int_status;
 }
 
-unsigned int exynos4_jpeg_get_fifo_status(void __iomem *base)
-{
-	unsigned int fifo_status;
-
-	fifo_status = readl(base + EXYNOS4_FIFO_STATUS_REG);
-
-	return fifo_status;
-}
-
 void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
 {
 	unsigned int	reg;
@@ -186,18 +177,6 @@ void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
 					base + EXYNOS4_JPEG_CNTL_REG);
 }
 
-void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value)
-{
-	unsigned int	reg;
-
-	reg = readl(base + EXYNOS4_JPEG_CNTL_REG) & ~(EXYNOS4_SYS_INT_EN);
-
-	if (value == 1)
-		writel(reg | EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
-	else
-		writel(reg & ~EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
-}
-
 void exynos4_jpeg_set_stream_buf_address(void __iomem *base,
 					 unsigned int address)
 {
@@ -255,22 +234,8 @@ void exynos4_jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size)
 	writel(size, base + EXYNOS4_BITSTREAM_SIZE_REG);
 }
 
-void exynos4_jpeg_get_frame_size(void __iomem *base,
-			unsigned int *width, unsigned int *height)
-{
-	*width = (readl(base + EXYNOS4_DECODE_XY_SIZE_REG) &
-				EXYNOS4_DECODED_SIZE_MASK);
-	*height = (readl(base + EXYNOS4_DECODE_XY_SIZE_REG) >> 16) &
-				EXYNOS4_DECODED_SIZE_MASK;
-}
-
 unsigned int exynos4_jpeg_get_frame_fmt(void __iomem *base)
 {
 	return readl(base + EXYNOS4_DECODE_IMG_FMT_REG) &
 				EXYNOS4_JPEG_DECODED_IMG_FMT_MASK;
 }
-
-void exynos4_jpeg_set_timer_count(void __iomem *base, unsigned int size)
-{
-	writel(size, base + EXYNOS4_INT_TIMER_COUNT_REG);
-}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
index c228d28..19690e4 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
@@ -21,7 +21,6 @@ void exynos4_jpeg_set_enc_tbl(void __iomem *base);
 void exynos4_jpeg_set_interrupt(void __iomem *base);
 unsigned int exynos4_jpeg_get_int_status(void __iomem *base);
 void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value);
-void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value);
 void exynos4_jpeg_set_stream_buf_address(void __iomem *base,
 					 unsigned int address);
 void exynos4_jpeg_set_stream_size(void __iomem *base,
@@ -33,10 +32,6 @@ void exynos4_jpeg_set_encode_tbl_select(void __iomem *base,
 void exynos4_jpeg_set_encode_hoff_cnt(void __iomem *base, unsigned int fmt);
 void exynos4_jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size);
 unsigned int exynos4_jpeg_get_stream_size(void __iomem *base);
-void exynos4_jpeg_get_frame_size(void __iomem *base,
-			unsigned int *width, unsigned int *height);
 unsigned int exynos4_jpeg_get_frame_fmt(void __iomem *base);
-unsigned int exynos4_jpeg_get_fifo_status(void __iomem *base);
-void exynos4_jpeg_set_timer_count(void __iomem *base, unsigned int size);
 
 #endif /* JPEG_HW_EXYNOS4_H_ */
-- 
1.7.10.4


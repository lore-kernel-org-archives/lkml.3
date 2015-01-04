Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbbADP3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:29:47 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51299 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbADP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:29:46 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-jpeg: Remove some unused functions
Date: Sun,  4 Jan 2015 16:32:45 +0100
Message-Id: <1420385565-12091-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
s5p_jpeg_input_raw_y16() s5p_jpeg_timer_disable() s5p_jpeg_timer_enable()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c |   32 -------------------------
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h |    3 ---
 2 files changed, 35 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
index e3b8e67..b5f20e7 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c
@@ -51,18 +51,6 @@ void s5p_jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGCMOD);
 }
 
-void s5p_jpeg_input_raw_y16(void __iomem *regs, bool y16)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGCMOD);
-	if (y16)
-		reg |= S5P_MODE_Y16;
-	else
-		reg &= ~S5P_MODE_Y16_MASK;
-	writel(reg, regs + S5P_JPGCMOD);
-}
-
 void s5p_jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 {
 	unsigned long reg, m;
@@ -208,26 +196,6 @@ void s5p_jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
 	writel(reg, regs + S5P_JPGINTSE);
 }
 
-void s5p_jpeg_timer_enable(void __iomem *regs, unsigned long val)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_TIMER_SE);
-	reg |= S5P_TIMER_INT_EN;
-	reg &= ~S5P_TIMER_INIT_MASK;
-	reg |= val & S5P_TIMER_INIT_MASK;
-	writel(reg, regs + S5P_JPG_TIMER_SE);
-}
-
-void s5p_jpeg_timer_disable(void __iomem *regs)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_TIMER_SE);
-	reg &= ~S5P_TIMER_INT_EN_MASK;
-	writel(reg, regs + S5P_JPG_TIMER_SE);
-}
-
 int s5p_jpeg_timer_stat(void __iomem *regs)
 {
 	return (int)((readl(regs + S5P_JPG_TIMER_ST) & S5P_TIMER_INT_STAT_MASK)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
index c11ebe8..f208fa3 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
@@ -29,7 +29,6 @@
 void s5p_jpeg_reset(void __iomem *regs);
 void s5p_jpeg_poweron(void __iomem *regs);
 void s5p_jpeg_input_raw_mode(void __iomem *regs, unsigned long mode);
-void s5p_jpeg_input_raw_y16(void __iomem *regs, bool y16);
 void s5p_jpeg_proc_mode(void __iomem *regs, unsigned long mode);
 void s5p_jpeg_subsampling_mode(void __iomem *regs, unsigned int mode);
 unsigned int s5p_jpeg_get_subsampling_mode(void __iomem *regs);
@@ -42,8 +41,6 @@ void s5p_jpeg_x(void __iomem *regs, unsigned int x);
 void s5p_jpeg_rst_int_enable(void __iomem *regs, bool enable);
 void s5p_jpeg_data_num_int_enable(void __iomem *regs, bool enable);
 void s5p_jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl);
-void s5p_jpeg_timer_enable(void __iomem *regs, unsigned long val);
-void s5p_jpeg_timer_disable(void __iomem *regs);
 int s5p_jpeg_timer_stat(void __iomem *regs);
 void s5p_jpeg_clear_timer_stat(void __iomem *regs);
 void s5p_jpeg_enc_stream_int(void __iomem *regs, unsigned long size);
-- 
1.7.10.4


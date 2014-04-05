Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaDESYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:24:07 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58909 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaDESYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:24:05 -0400
MIME-Version: 1.0
Date: Sat, 5 Apr 2014 20:24:04 +0200
Message-ID: <CAPF_0gn1r1R0eatLDqKUqmMc=n9xYufxbg==zv3RS4wS8fbJpA@mail.gmail.com>
Subject: [PATCH 1/1] staging: sep: Fix coding style
From: Camille Bordignon <camille.bordignon@gmail.com>
To: paul.gortmaker@windriver.com, rashika.kheria@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes coding style warning "Missing a blank line after
declarations" in files sep_dev.h and sep_crypto.c.

Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
---
diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 965485f..415f8ec 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -93,6 +93,7 @@ static void sep_do_callback(struct work_struct *work)
 {
     struct sep_work_struct *sep_work = container_of(work,
         struct sep_work_struct, work);
+
     if (sep_work != NULL) {
         (sep_work->callback)(sep_work->data);
         kfree(sep_work);
@@ -649,6 +650,7 @@ weak:
 static u32 sep_sg_nents(struct scatterlist *sg)
 {
     u32 ct1 = 0;
+
     while (sg) {
         ct1 += 1;
         sg = sg_next(sg);
@@ -666,6 +668,7 @@ static u32 sep_sg_nents(struct scatterlist *sg)
 static u32 sep_start_msg(struct this_task_ctx *ta_ctx)
 {
     u32 *word_ptr;
+
     ta_ctx->msg_len_words = 2;
     ta_ctx->msgptr = ta_ctx->msg;
     memset(ta_ctx->msg, 0, SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES);
@@ -740,6 +743,7 @@ static void sep_write_msg(struct this_task_ctx
*ta_ctx, void *in_addr,
 {
     u32 *word_ptr;
     void *void_ptr;
+
     void_ptr = ta_ctx->msgptr + *msg_offset;
     word_ptr = (u32 *)void_ptr;
     memcpy(void_ptr, in_addr, size);
@@ -748,6 +752,7 @@ static void sep_write_msg(struct this_task_ctx
*ta_ctx, void *in_addr,
     /* Do we need to manipulate endian? */
     if (byte_array) {
         u32 i;
+
         for (i = 0; i < ((size + 3) / 4); i += 1)
             *(word_ptr + i) = CHG_ENDIAN(*(word_ptr + i));
     }
@@ -788,12 +793,14 @@ static void sep_read_msg(struct this_task_ctx
*ta_ctx, void *in_addr,
 {
     u32 *word_ptr;
     void *void_ptr;
+
     void_ptr = ta_ctx->msgptr + *msg_offset;
     word_ptr = (u32 *)void_ptr;

     /* Do we need to manipulate endian? */
     if (byte_array) {
         u32 i;
+
         for (i = 0; i < ((size + 3) / 4); i += 1)
             *(word_ptr + i) = CHG_ENDIAN(*(word_ptr + i));
     }
@@ -865,6 +872,7 @@ static void sep_read_context(struct this_task_ctx
*ta_ctx, u32 *msg_offset,
     void *dst, u32 len)
 {
     u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+
     sep_read_msg(ta_ctx, dst, len, max_length, msg_offset, 0);
 }

@@ -884,6 +892,7 @@ static void sep_write_context(struct this_task_ctx
*ta_ctx, u32 *msg_offset,
     void *src, u32 len)
 {
     u32 max_length = ((len + 3) / sizeof(u32)) * sizeof(u32);
+
     sep_write_msg(ta_ctx, src, len, max_length, msg_offset, 0);
 }

@@ -3893,6 +3902,7 @@ static struct crypto_alg crypto_algs[] = {
 int sep_crypto_setup(void)
 {
     int err, i, j, k;
+
     tasklet_init(&sep_dev->finish_tasklet, sep_finish,
         (unsigned long)sep_dev);

diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 5f6a07f..bf56c06 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -152,6 +152,7 @@ static inline u32 sep_read_reg(struct sep_device
*dev, int reg)
 static inline void sep_wait_sram_write(struct sep_device *dev)
 {
     u32 reg_val;
+
     do {
         reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
     } while (!(reg_val & 1));

-- 
Camille Bordignon

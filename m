Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3HFDgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:36:23 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:52359 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3HFDgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:36:20 -0400
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 11:36:19 +0800
Message-ID: <CAAfg0W4jCXqfthyQi3X+hvznrnksDeJfSpKoymnc53fE=dRN9w@mail.gmail.com>
Subject: [PATCH] warning-elimination: android: binder
From: Andy Green <andy.green@linaro.org>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: John Stultz <john.stultz@linaro.org>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Green <andy.green@linaro.org>

warning-elimination: android: binder

This commit in mainline (now) causes a couple of warnings

commit 975a1ac9a9fe65d66ee1726c0db6dc58e53d232a
Author: Arve Hjønnevåg <arve@android.com>
Date:   Tue Oct 16 15:29:53 2012 -0700

    Staging: android: binder: Add some tracepoints

This patch fixes them

Signed-off-by: Andy Green <andy.green@linaro.org>
---

diff --git a/drivers/staging/android/binder_trace.h
b/drivers/staging/android/binder_trace.h
index 82a567c..c661e37 100644
--- a/drivers/staging/android/binder_trace.h
+++ b/drivers/staging/android/binder_trace.h
@@ -159,7 +159,7 @@ TRACE_EVENT(binder_transaction_node_to_ref,
  TP_fast_assign(
  __entry->debug_id = t->debug_id;
  __entry->node_debug_id = node->debug_id;
- __entry->node_ptr = node->ptr;
+ __entry->node_ptr = (void __user *)node->ptr;
  __entry->ref_debug_id = ref->debug_id;
  __entry->ref_desc = ref->desc;
  ),
@@ -184,7 +184,7 @@ TRACE_EVENT(binder_transaction_ref_to_node,
  __entry->ref_debug_id = ref->debug_id;
  __entry->ref_desc = ref->desc;
  __entry->node_debug_id = ref->node->debug_id;
- __entry->node_ptr = ref->node->ptr;
+ __entry->node_ptr = (void __user *)ref->node->ptr;
  ),
  TP_printk("transaction=%d node=%d src_ref=%d src_desc=%d ==> dest_ptr=0x%p",
   __entry->debug_id, __entry->node_debug_id,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3GOIej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:34:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15755 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3GOIei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:34:38 -0400
Message-ID: <51E3B3B2.4080307@huawei.com>
Date: Mon, 15 Jul 2013 16:32:50 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing: typo fix on ring buffer comments
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have some mismatch between comments with
real function name, update it.

This patch also add some missed function arguments
description.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/ring_buffer.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index eef2e56..cc2f66f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1066,7 +1066,7 @@ static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
 }

 /**
- * check_pages - integrity check of buffer pages
+ * rb_check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
  *
  * As a safety measure we check to make sure the data pages have not
@@ -1258,7 +1258,7 @@ static int rb_cpu_notify(struct notifier_block *self,
 #endif

 /**
- * ring_buffer_alloc - allocate a new ring_buffer
+ * __ring_buffer_alloc - allocate a new ring_buffer
  * @size: the size in bytes per cpu that is needed.
  * @flags: attributes to set for the ring buffer.
  *
@@ -1607,6 +1607,7 @@ static void update_pages_handler(struct work_struct *work)
  * ring_buffer_resize - resize the ring buffer
  * @buffer: the buffer to resize.
  * @size: the new size.
+ * @cpu_id: the cpu buffer to resize
  *
  * Minimum size is 2 * BUF_PAGE_SIZE.
  *
@@ -3956,11 +3957,11 @@ EXPORT_SYMBOL_GPL(ring_buffer_consume);
  * expected.
  *
  * After a sequence of ring_buffer_read_prepare calls, the user is
- * expected to make at least one call to ring_buffer_prepare_sync.
+ * expected to make at least one call to ring_buffer_read_prepare_sync.
  * Afterwards, ring_buffer_read_start is invoked to get things going
  * for real.
  *
- * This overall must be paired with ring_buffer_finish.
+ * This overall must be paired with ring_buffer_read_finish.
  */
 struct ring_buffer_iter *
 ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu)
@@ -4009,7 +4010,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_prepare_sync);
  * an intervening ring_buffer_read_prepare_sync must have been
  * performed.
  *
- * Must be paired with ring_buffer_finish.
+ * Must be paired with ring_buffer_read_finish.
  */
 void
 ring_buffer_read_start(struct ring_buffer_iter *iter)
@@ -4031,7 +4032,7 @@ ring_buffer_read_start(struct ring_buffer_iter *iter)
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);

 /**
- * ring_buffer_finish - finish reading the iterator of the buffer
+ * ring_buffer_read_finish - finish reading the iterator of the buffer
  * @iter: The iterator retrieved by ring_buffer_start
  *
  * This re-enables the recording to the buffer, and frees the
@@ -4346,6 +4347,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 /**
  * ring_buffer_alloc_read_page - allocate a page to read from buffer
  * @buffer: the buffer to allocate for.
+ * @cpu: the cpu buffer to allocate.
  *
  * This function is used in conjunction with ring_buffer_read_page.
  * When reading a full page from the ring buffer, these functions
@@ -4403,7 +4405,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
  * to swap with a page in the ring buffer.
  *
  * for example:
- *	rpage = ring_buffer_alloc_read_page(buffer);
+ *	rpage = ring_buffer_alloc_read_page(buffer, cpu);
  *	if (!rpage)
  *		return error;
  *	ret = ring_buffer_read_page(buffer, &rpage, len, cpu, 0);
-- 
1.7.9.7



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbaGYOGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:06:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:40495 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759996AbaGYOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:06:15 -0400
Message-Id: <20140725140612.648009076@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 25 Jul 2014 10:05:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 2/4] ring-buffer: Use rb_page_size() instead of open coded head_page size
References: <20140725140514.377803118@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ring-buffer-Use-rb_page_size-instead-of-open-coded-h.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's a helper function to get a ring buffer page size (the number
of bytes of data recorded on the page), called rb_page_size().
Use that instead of open coding it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 35825a87d6a3..d8c267ec5cca 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3763,7 +3763,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
-	if (iter->head >= local_read(&iter->head_page->page->commit)) {
+	if (iter->head >= rb_page_size(iter->head_page)) {
 		rb_inc_iter(iter);
 		goto again;
 	}
-- 
2.0.1



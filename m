Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbaGCQRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:17:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:3195 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759186AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161225.405197193@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [for-next][PATCH 11/21] tracing: Remove trace_seq_reserve()
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0011-tracing-Remove-trace_seq_reserve.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

trace_seq_reserve() has no users in the kernel, it just wastes space.
Remove it.

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h |  5 -----
 kernel/trace/trace_seq.c  | 30 ------------------------------
 2 files changed, 35 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 8283762ab7ef..dd85753e1bb0 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -43,7 +43,6 @@ extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
 extern int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len);
 extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 				unsigned int len);
-extern void *trace_seq_reserve(struct trace_seq *s, unsigned int len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
 
 extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
@@ -94,10 +93,6 @@ static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 {
 	return 0;
 }
-static inline void *trace_seq_reserve(struct trace_seq *s, unsigned int len)
-{
-	return NULL;
-}
 static inline int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
 	return 0;
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 88c0f80f0a1f..1f24ed99dca2 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -342,36 +342,6 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
 /**
- * trace_seq_reserve - reserve space on the sequence buffer
- * @s: trace sequence descriptor
- * @len: The amount to reserver.
- *
- * If for some reason there is a need to save some space on the
- * buffer to fill in later, this function is used for that purpose.
- * The given length will be reserved and the pointer to that
- * location on the buffer is returned, unless there is not enough
- * buffer left to hold the given length then NULL is returned.
- */
-void *trace_seq_reserve(struct trace_seq *s, unsigned int len)
-{
-	void *ret;
-
-	if (s->full)
-		return NULL;
-
-	if (len > TRACE_SEQ_BUF_LEFT(s)) {
-		s->full = 1;
-		return NULL;
-	}
-
-	ret = s->buffer + s->len;
-	s->len += len;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(trace_seq_reserve);
-
-/**
  * trace_seq_path - copy a path into the sequence buffer
  * @s: trace sequence descriptor
  * @path: path to write into the sequence buffer.
-- 
2.0.0



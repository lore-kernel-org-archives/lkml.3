Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaKOFJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:09:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4037 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751400AbaKOFGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:06 -0500
Message-Id: <20141115050603.317258681@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:59:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 16/26 v5] tracing: Convert seq_buf fields to be like seq_file fields
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0016-tracing-Convert-seq_buf-fields-to-be-like-seq_file-f.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In facilitating the conversion of seq_file to use seq_buf,
have the seq_buf fields match the types used by seq_file.

Link: http://lkml.kernel.org/r/20141104160222.195301024@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 38770688a627..d14dc9023dde 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -16,10 +16,10 @@
  * @readpos:	The next position to read in the buffer.
  */
 struct seq_buf {
-	unsigned char		*buffer;
-	unsigned int		size;
-	unsigned int		len;
-	unsigned int		readpos;
+	char			*buffer;
+	size_t			size;
+	size_t			len;
+	loff_t			readpos;
 };
 
 static inline void
-- 
2.1.1



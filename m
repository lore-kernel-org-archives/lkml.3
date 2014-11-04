Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaKDQFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:05:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:51874 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754617AbaKDQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:29 -0500
Message-Id: <20141104160222.195301024@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 05/12 v3] tracing: Convert seq_buf fields to be like seq_file fields
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Convert-seq_buf-fields-to-be-like-seq_file-f.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In facilitating the conversion of seq_file to use seq_buf,
have the seq_buf fields match the types used by seq_file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 6d1c57d6073f..a4d114e6f740 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -19,10 +19,10 @@
  * @overflow:	Set if more bytes should have been written to buffer
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



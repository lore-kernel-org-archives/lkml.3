Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096AbaKNBRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:17:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:27203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934934AbaKNBOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:17 -0500
Message-Id: <20141114011412.636548251@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:13:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 16/23 v4] tracing: Add a seq_buf_clear() helper and clear len and readpos in
 init
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0016-tracing-Add-a-seq_buf_clear-helper-and-clear-len-and.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a helper function seq_buf_clear() that resets the len and readpos
fields of a seq_buf. Currently it is only used in the seq_buf_init()
but will be used later when updating the seq_file code.

Link: http://lkml.kernel.org/r/20141104160222.352309995@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seq_buf.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index d14dc9023dde..5d91262433e2 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -22,13 +22,18 @@ struct seq_buf {
 	loff_t			readpos;
 };
 
+static inline void seq_buf_clear(struct seq_buf *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
 static inline void
 seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
 {
 	s->buffer = buf;
 	s->size = size;
-	s->len = 0;
-	s->readpos = 0;
+	seq_buf_clear(s);
 }
 
 /*
-- 
2.1.1



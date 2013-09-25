Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3IYWtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3IYWtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:49:23 -0400
Date: Wed, 25 Sep 2013 18:49:13 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: tracing: don't stuff stale pointers in filp->private_data
Message-ID: <20130925224912.GA23473@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130920164732.GA31520@redhat.com>
 <20130921143255.GS13318@ZenIV.linux.org.uk>
 <cd5db43e-160e-448a-9708-3c5e44c0d34c@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd5db43e-160e-448a-9708-3c5e44c0d34c@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably harmless, but still not a nice thing to do.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..27aa16e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1124,10 +1124,10 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	if (ret < 0) {
 		trace_array_put(tr);
 		kfree(dir);
+	} else {
+		filp->private_data = dir;
 	}
 
-	filp->private_data = dir;
-
 	return ret;
 }
 

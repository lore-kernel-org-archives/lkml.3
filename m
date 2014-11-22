Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaKVS2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:28:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaKVS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:28:49 -0500
Date: Sat, 22 Nov 2014 21:30:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] tracing: remove unneeded NULL check
Message-ID: <20141122183012.GB6994@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We checked "iter->trace" earlier so there is no need to check here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9ddd6aa..52fbbc5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3019,7 +3019,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	mutex_init(&iter->mutex);
 
 	/* Notify the tracer early; before we stop tracing. */
-	if (iter->trace && iter->trace->open)
+	if (iter->trace->open)
 		iter->trace->open(iter);
 
 	/* Annotate start of buffers if we had overruns */

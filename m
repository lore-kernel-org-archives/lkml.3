Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3AWUgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:36:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3AWUeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:36 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VbS99tqcae4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZXR7CVCJTfQA:10 a=20KFwNOVAAAA:8 a=NhHFxEObECT-Fu7-YnsA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203435.053183845@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/12 -next] ring-buffer: Remove trace.h from ring_buffer.c
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0012-ring-buffer-Remove-trace.h-from-ring_buffer.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

ring_buffer.c use to require declarations from trace.h, but
these have moved to the generic header files. There's nothing
in trace.h that ring_buffer.c requires.

There's some headers that trace.h included that ring_buffer.c
needs, but it's best that it includes them directly, and not
include trace.h.

Also, some things may use ring_buffer.c without having tracing
configured. This removes the dependency that may come in the
future.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 481e262..13950d9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3,8 +3,10 @@
  *
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
  */
+#include <linux/ftrace_event.h>
 #include <linux/ring_buffer.h>
 #include <linux/trace_clock.h>
+#include <linux/trace_seq.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
@@ -21,7 +23,6 @@
 #include <linux/fs.h>
 
 #include <asm/local.h>
-#include "trace.h"
 
 static void update_pages_handler(struct work_struct *work);
 
-- 
1.7.10.4



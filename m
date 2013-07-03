Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3GCLhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3GCLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:22 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uvMupPA12AsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2spw1KISb_kA:10 a=QyXUC8HyAAAA:8 a=LxymJPAJh60Og38CkN8A:9 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113719.668969153@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [for-next][PATCH 8/8] tracing: Make tracing_open_generic_{tr,tc}() static
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Make-tracing_open_generic_-tr-tc-static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

I have patches that will use tracing_open_generic_tr/tc() in other
files, but as they are not ready to be merged yet, and Fengguang Wu's
sparse scripts pointed out that these functions were not declared
anywhere, I'll make them static for now.

When these functions are required to be used elsewhere, I'll remove
the static then.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f6fed9e..dc473b5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2960,7 +2960,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
  */
-int tracing_open_generic_tr(struct inode *inode, struct file *filp)
+static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 {
 	struct trace_array *tr = inode->i_private;
 
@@ -2976,7 +2976,7 @@ int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 	
 }
 
-int tracing_open_generic_tc(struct inode *inode, struct file *filp)
+static int tracing_open_generic_tc(struct inode *inode, struct file *filp)
 {
 	struct trace_cpu *tc = inode->i_private;
 	struct trace_array *tr = tc->tr;
-- 
1.7.10.4



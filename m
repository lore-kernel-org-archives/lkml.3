Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaCFPe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:34:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14827 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbaCFPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:34:27 -0500
Date: Thu, 6 Mar 2014 10:34:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/module: Replace include of tracepoint.h with
 jump_label.h in module.h
Message-ID: <20140306103414.15ab227a@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rusty,

Can you give an Acked-by for this patch so that I can include it in my
3.15 queue. I have some patches there that need to be added before this
change can go in.

Thanks,

-- Steve


----
There's nothing in the module.h header that requires tracepoint.h to be
included, and there may be cases that tracepoint.h may need to include
module.h, which will cause recursive header issues.

But module.h requires seeing HAVE_JUMP_LABEL which is set in
jump_label.h which it just coincidentally gets from tracepoint.h.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..5a50539 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
-#include <linux/tracepoint.h>
+#include <linux/jump_label.h>
 #include <linux/export.h>
 
 #include <linux/percpu.h>
-- 
1.8.5.3


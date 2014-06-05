Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaFES1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:27:07 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:22945 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbaFES1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:27:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAES2kFNXQDfT/2dsb2JhbABZgwesCQUBmCeBDxd0gwIjgRo3iEYB00IXhVWIfR2EKgSPTopFkzmDOjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Rostedt <rostedt@goodmis.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/trace/blktrace.c: logging clean-up
Date: Thu,  5 Jun 2014 20:25:34 +0200
Message-Id: <1401992734-10923-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Remove "Warning:" from logging (already in log level)
-Convert pr_warning to standard pr_warn
-Define pr_fmt(fmt) fmt to avoid any future default fmt definition

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/blktrace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c1bd4ad..a8d83d0 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -15,6 +15,9 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  */
+
+#define pr_fmt(fmt) fmt
+
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
@@ -1467,12 +1470,12 @@ static struct trace_event trace_blk_event = {
 static int __init init_blk_tracer(void)
 {
 	if (!register_ftrace_event(&trace_blk_event)) {
-		pr_warning("Warning: could not register block events\n");
+		pr_warn("could not register block events\n");
 		return 1;
 	}
 
 	if (register_tracer(&blk_tracer) != 0) {
-		pr_warning("Warning: could not register the block tracer\n");
+		pr_warn("could not register the block tracer\n");
 		unregister_ftrace_event(&trace_blk_event);
 		return 1;
 	}
-- 
1.8.4.5


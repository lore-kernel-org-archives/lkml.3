Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbaKTPTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:19:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37553 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbaKTPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:19:15 -0500
Date: Thu, 20 Nov 2014 10:19:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [for-next][PATCH] tracing: Deletion of an unnecessary check before
 iput()
Message-ID: <20141120101903.17a92fed@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 16a8ef2751801346f1f76a18685b2beb63cd170f


Markus Elfring (1):
      tracing: Deletion of an unnecessary check before iput()

----
 kernel/trace/trace_uprobe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
---------------------------
commit 16a8ef2751801346f1f76a18685b2beb63cd170f
Author: Markus Elfring <elfring@users.sourceforge.net>
Date:   Sun Nov 16 14:46:28 2014 +0100

    tracing: Deletion of an unnecessary check before iput()
    
    The iput() function tests whether its argument is NULL and then
    returns immediately. Thus the test around the call is not needed.
    
    This issue was detected by using the Coccinelle software.
    
    Link: http://lkml.kernel.org/r/5468F875.7080907@users.sourceforge.net
    
    Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index fd76f8e108ef..8520acc34b18 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -552,8 +552,7 @@ error:
 	return ret;
 
 fail_address_parse:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	pr_info("Failed to parse address or file.\n");
 

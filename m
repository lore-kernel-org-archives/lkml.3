Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaFITBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:01:36 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:37738 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753731AbaFITBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:01:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3868:3871:3874:4321:4419:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: event49_47a844d9cbe19
X-Filterd-Recvd-Size: 1722
Message-ID: <1402340490.3142.14.camel@joe-AO725>
Subject: [PATCH -next] proc_sysctl: convert use of typedef ctl_table to
 struct ctl_table
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 12:01:30 -0700
In-Reply-To: <1402336292.3142.8.camel@joe-AO725>
References: <1402336292.3142.8.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Remove the last actual use of typedef ctl_table.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Mon, 2014-06-09 at 10:51 -0700, Joe Perches wrote:
> All the uses have been removed so remove the typedef.

Not so fast buckwheat.
I was showing off my obviously insufficient grep skills...

There's still this one.

These patches need reordering so that this one is first...

 fs/proc/proc_sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7129046..f92d5dd 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -632,7 +632,7 @@ out:
 	return ret;
 }
 
-static int scan(struct ctl_table_header *head, ctl_table *table,
+static int scan(struct ctl_table_header *head, struct ctl_table *table,
 		unsigned long *pos, struct file *file,
 		struct dir_context *ctx)
 {



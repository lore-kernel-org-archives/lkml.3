Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaCEWel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:34:41 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:58950 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932387AbaCEWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:34:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2376:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3874:4321:5007:7652:8660:10004:10400:10848:11026:11232:11473:11658:11914:12296:12438:12517:12519:12555:12740:13069:13148:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kick38_7fc63ec66382a
X-Filterd-Recvd-Size: 1956
Message-ID: <1394058876.12070.26.camel@joe-AO722>
Subject: Re: [PATCH] audit: remove stray newlines from audit_log_lost
 messages
From: Joe Perches <joe@perches.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 14:34:36 -0800
In-Reply-To: <20140305222703.GW16640@madcap2.tricolour.ca>
References: <20140305212955.GV6301@hansolo.jdub.homelinux.org>
	 <20140305222703.GW16640@madcap2.tricolour.ca>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 17:27 -0500, Richard Guy Briggs wrote:
> On 14/03/05, Josh Boyer wrote:
> > Calling audit_log_lost with a \n in the format string leads to extra
> > newlines in dmesg.  That function will eventually call audit_panic which
> > uses pr_err with an explicit \n included.  Just make these calls match the
> > others that lack \n.
> > 
> > Reported-by: Jonathan Kamens <jik@kamens.brookline.ma.us>
> > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> 
> Ack.  queued.

There's an unnecessary use of a \n in audit_panic too
---
 kernel/auditsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7aef2f4..da93d2e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1157,7 +1157,7 @@ static void audit_log_execve_info(struct audit_context *context,
 	 */
 	buf = kmalloc(MAX_EXECVE_AUDIT_LEN + 1, GFP_KERNEL);
 	if (!buf) {
-		audit_panic("out of memory for argv string\n");
+		audit_panic("out of memory for argv string");
 		return;
 	}
 



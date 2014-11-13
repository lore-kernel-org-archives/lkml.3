Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbaKMTzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:55:33 -0500
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:51648 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933526AbaKMTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:55:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3876:3877:5007:6114:6261:6642:10004:10400:10848:11232:11658:11914:12517:12519:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: screw18_4d38f6fa6a239
X-Filterd-Recvd-Size: 896
Message-ID: <1415908529.4223.11.camel@perches.com>
Subject: spatch for trivial pointer comparison style?
From: Joe Perches <joe@perches.com>
To: cocci <cocci@systeme.lip6.fr>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 11:55:29 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added a checkpatch entry for this.
Maybe some cocci test like this would be useful?

@@
type t;
t *p;
@@
-	p == NULL
+	!p

@@
type t;
t *p;
@@
-	p != NULL
+	p

@@
type t;
t *p;
@@
-	NULL == p
+	!p

@@
type t;
t *p;
@@
-	NULL != p
+	p



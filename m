Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaAXW4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:56:35 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:38248 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087AbaAXW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:56:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12555:12663:12740:13019:13069:13072:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flock66_1bdfda009d056
X-Filterd-Recvd-Size: 3239
Message-ID: <1390604188.32356.34.camel@joe-AO722>
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 24 Jan 2014 14:56:28 -0800
In-Reply-To: <alpine.DEB.2.02.1401240221370.9846@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
	 <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
	 <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org>
	 <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
	 <1390521727.32356.16.camel@joe-AO722>
	 <alpine.DEB.2.02.1401240221370.9846@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 02:27 -0800, David Rientjes wrote:
> On Thu, 23 Jan 2014, Joe Perches wrote:
> 
> > > > get_maintainer's default output should answer the question "who do I
> > > > email about this file", and that ain't working :(
> > 
> > Complaints cheerfully ignored.
> > Suggestions gratefully accepted.
> > 
> > Files that haven't had changes in a long time
> > generally aren't maintained.
> > 
> > Old addresses frequently become stale and bounce.
> > 
> > It'd be better if there was a MAINTAINERS entry
> > for drivers/firmware/google.
> > 
> 
> I think scripts/get_maintainer.pl is only really useful for emailing 
> patches so I think outputting at least somebody to cc on patches would be 
> a good idea.  It doesn't necessarily need to be someone who maintains the 
> code and pushes it to Linus.

Very very few people listed in MAINTAINERS actual push to Linus.

> I'm not sure how much runtime is a factor for people of the script, but 
> falling back to git-blame behavior to at least get one or two cc's sounds 
> appropriate.  If the email address is outdated, owell, we live and learn.

Maybe something like this would work.
It uses git-blame whenever no maintainers are found.
---
 scripts/get_maintainer.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 9c3986f..ef05ed6 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -483,6 +483,13 @@ my %deduplicate_address_hash = ();
 
 my @maintainers = get_maintainers();
 
+if ($email_maintainer && !$interactive && !$email_git_blame &&
+    (!@maintainers || ($email_list && @maintainers == 1))) {
+    warn "$P: No maintainer found, trying harder, addresses may be stale...\n";
+    $email_git_blame = 1;
+    @maintainers = get_maintainers();
+}
+
 if (@maintainers) {
     @maintainers = merge_email(@maintainers);
     output(@maintainers);




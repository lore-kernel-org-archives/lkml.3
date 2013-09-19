Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3ISVpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:45:36 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:58447 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753374Ab3ISVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:45:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 13,1.2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2525:2561:2564:2682:2685:2693:2828:2859:2892:2903:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3653:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6691:7652:7903:8527:8957:9010:9025:9072:9388:10008:10049:10848:11232:11658:11914:12043:12050:12114:12295:12485:12517:12519:12555:1
X-HE-Tag: cough24_13330d58aa610
X-Filterd-Recvd-Size: 5423
Message-ID: <1379627130.5862.2.camel@joe-AO722>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
 rules
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, stephen@networkplumber.org,
        netdev@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Sep 2013 14:45:30 -0700
In-Reply-To: <20130919213241.GB31672@electric-eye.fr.zoreil.com>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	 <20130919.135628.1201613770803318193.davem@davemloft.net>
	 <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	 <1379615474.22168.13.camel@joe-AO722>
	 <20130919213241.GB31672@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 23:32 +0200, Francois Romieu wrote:
> Joe Perches <joe@perches.com> :
> [...]
> > diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
> > index b0714d8..a2d6da0 100644
> > --- a/Documentation/stable_kernel_rules.txt
> > +++ b/Documentation/stable_kernel_rules.txt
> > @@ -29,6 +29,11 @@ Rules on what kind of patches are accepted, and which ones are not, into the
> >  
> >  Procedure for submitting patches to the -stable tree:
> >  
> > + - The networking tree (net/ and drivers/net/) is 'special' and doesn't
> > +   follow the rules below.  Don't send or cc: patches for the -stable tree to
> > +   stable@vger.kernel.org.  Don't mark them stable.  Just send the patches to
> > +   netdev@vger.kernel.org and let the networking maintainer decide what to do
> > +   with them.
> 
> David said "simply ask me to queue them up for -stable explicitly".
> 
> He did not say "send the patches and let me decide what to do with them".
> 

David selects them regardless.

from Documentation/networking/netdev-FAQ.txt:

Q: How can I tell what patches are queued up for backporting to the
   various stable releases?

A: Normally Greg Kroah-Hartman collects stable commits himself, but
   for networking, Dave collects up patches he deems critical for the
   networking subsystem, and then hands them off to Greg.

   There is a patchworks queue that you can see here:
	http://patchwork.ozlabs.org/bundle/davem/stable/?state=*

   It contains the patches which Dave has selected, but not yet handed
   off to Greg.  If Greg already has the patch, then it will be here:
	http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git

   A quick way to find whether the patch is in this stable-queue is
   to simply clone the repo, and then git grep the mainline commit ID, e.g.

	stable-queue$ git grep -l 284041ef21fdf2e
	releases/3.0.84/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
	releases/3.4.51/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
	releases/3.9.8/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
	stable/stable-queue$

Q: I see a network patch and I think it should be backported to stable.
   Should I request it via "stable@vger.kernel.org" like the references in
   the kernel's Documentation/stable_kernel_rules.txt file say?

A: No, not for networking.  Check the stable queues as per above 1st to see
   if it is already queued.  If not, then send a mail to netdev, listing
   the upstream commit ID and why you think it should be a stable candidate.

   Before you jump to go do the above, do note that the normal stable rules
   in Documentation/stable_kernel_rules.txt still apply.  So you need to
   explicitly indicate why it is a critical fix and exactly what users are
   impacted.  In addition, you need to convince yourself that you _really_
   think it has been overlooked, vs. having been considered and rejected.

   Generally speaking, the longer it has had a chance to "soak" in mainline,
   the better the odds that it is an OK candidate for stable.  So scrambling
   to request a commit be added the day after it appears should be avoided.

Q: I have created a network patch and I think it should be backported to
   stable.  Should I add a "Cc: stable@vger.kernel.org" like the references
   in the kernel's Documentation/ directory say?

A: No.  See above answer.  In short, if you think it really belongs in
   stable, then ensure you write a decent commit log that describes who
   gets impacted by the bugfix and how it manifests itself, and when the
   bug was introduced.  If you do that properly, then the commit will
   get handled appropriately and most likely get put in the patchworks
   stable queue if it really warrants it.

   If you think there is some valid information relating to it being in
   stable that does _not_ belong in the commit log, then use the three
   dash marker line as described in Documentation/SubmittingPatches to
   temporarily embed that information into the patch that you send.




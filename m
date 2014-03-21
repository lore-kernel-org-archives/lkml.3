Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbaCUPS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:18:28 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:36591 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760279AbaCUPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:18:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:6119:7652:10004:10400:10848:10967:11232:11658:11914:12295:12517:12519:12663:12740:13069:13095:13149:13230:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pies39_e2d1727c170d
X-Filterd-Recvd-Size: 2414
Message-ID: <1395415096.7776.90.camel@joe-AO722>
Subject: Re: checkpatch on Kconfig files
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2014 08:18:16 -0700
In-Reply-To: <20140321143642.404183e5@endymion.delvare>
References: <20140321094239.18aebf02@endymion.delvare>
	 <1395392257.7776.74.camel@joe-AO722>
	 <20140321132121.GL22728@two.firstfloor.org>
	 <20140321143642.404183e5@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 14:36 +0100, Jean Delvare wrote:
> Hi Andi,
> 
> On Fri, 21 Mar 2014 14:21:21 +0100, Andi Kleen wrote:
> > > I believe that was Andi Kleen's pet peeve,
> > > so I'll punt it back to him.
> > 
> > This was always in checkpatch. If you touch/move some existing
> > code it blames you for the issues that were already there.
> > 
> > Not specific to this check.
> 
> Actually it is. I was not moving the Kconfig entry, and I was not
> touching its help text either. Here checkpatch complained about
> something which was in the context of the patch, not in added or
> modified lines. I am not aware of any other check doing that,
> thankfully.

I think there's one other --strict test for alignment
that uses context lines to bleat a message

change something like:

-	printk(KERN_WARNING "long line %d\n",
 	       length);
to
+	pr_warn("long line %d\n",
 	       length);

changing just the printk -> pr_warn line but not the
length line below it and checkpatch will bleat a
"bad alignment" message.

> This is a false positive, and checkpatch explicitly asks for these to
> be reported. Which is what I'm doing. Better tools make future
> contributions better and easier.

Another option would be to change the message when
it's in context lines and not in added lines to
something other than a demand for help text.

Or make it a --strict only CHK message when it's in
context and not added as part of the submission.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaFFP0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:26:52 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:49875 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751902AbaFFP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:26:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:800:901:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2551:2553:2560:2563:2682:2685:2691:2693:2828:2829:2859:2899:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3657:3742:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4384:5007:6119:6248:7576:7652:7903:7904:8599:8603:8957:9007:9010:9025:9040:9545:10004:10400:10482:10848:11232:11658:11854:11914:12043:12050:12517:12519:12683:12740:12776:13095:13137:13150:13181:13229:13230:13231:13436:14039:14096:14097:19901:19997:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DN
X-HE-Tag: birth25_3b50390912546
X-Filterd-Recvd-Size: 3281
Message-ID: <1402068405.12513.5.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
From: Joe Perches <joe@perches.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Date: Fri, 06 Jun 2014 08:26:45 -0700
In-Reply-To: <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 15:08 +0000, Allan, Bruce W wrote:
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Thursday, June 05, 2014 6:36 PM
> > To: Allan, Bruce W
> > Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> > Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> > message size
> > 
> > On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> > > the maximum message size (100,000 characters) allowed by Majordomo at
> > > vger.kernel.org since that is where most Linux email lists are served.
> > 
> > I believe this is incorrect and the patch is unnecessary.
> 
> Actually, it is correct (it even says so at http://vger.kernel.org/majordomo-info.html).

where?

All it says there that's relevant is:

------------------------------------------
All email sent to there must be TEXT/PLAIN, there can be no multipart
messages, no VCARDs, nothing ``fancy''. In presence of such things,
Majordomo will very likely do the wrong thing. 

When you send there email, do make sure that all of the email headers,
both visible and transport level, have same addresses in them. People
experience problems when for example ``From:'', ``Sender:'' and possible
``Reply-To:'' headers present different addresses. The most common
manifestation is complete silence from VGER! 
------------------------------------------

> We just experienced 2 out of 4 patches in the initial RFC submittal of the Intel(R)
> QuickAssist Technology (QAT) driver being blocked by Majordomo from getting out
> on the linux-crypto mailing list.

Possible, but the largest patch I've seen recently
on linux-kernel is about .5 Meg, 5 times your limit.

>   It took a while to figure out the problem and had to
> break up those two blocked patches into smaller ones which went through fine.  I
> submitted this checkpatch patch in hopes to prevent others from having to figure out
> the same.

Maybe specific to crypto?

> > It'd maybe more interesting if the email header sizes
> > were calculated and if > 1024, then some bleating message
> > were emitted.

This specific bit, email headers > 1K in total size,
is an actual failure mode btw.



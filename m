Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3KDWYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:24:12 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:43375 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750819Ab3KDWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:24:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6691:7652:7903:8599:9025:9121:9388:10004:10400:10848:10967:11232:11233:11658:11914:12043:12262:12438:12517:12519:12679:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boy25_7b8b4a947a911
X-Filterd-Recvd-Size: 3104
Message-ID: <1383603847.28651.12.camel@joe-AO722>
Subject: Re: [PATCH V2] checkpatch: Improve "return is not a function" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 14:24:07 -0800
In-Reply-To: <20131104142125.9bdb91fae696a802ee0d6b3b@linux-foundation.org>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1383070766.12439.13.camel@joe-AO722> <526FFED4.4070902@linux.intel.com>
	 <1383071755.12439.17.camel@joe-AO722> <52700D4C.10008@linux.intel.com>
	 <1383075490.12439.26.camel@joe-AO722> <1383261164.2769.6.camel@joe-AO722>
	 <20131104142125.9bdb91fae696a802ee0d6b3b@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-04 at 14:21 -0800, Andrew Morton wrote:
> On Thu, 31 Oct 2013 16:12:44 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > This now uses the "$balanced_parens" test and also makes
> > the test depend on perl v5.10 and higher.
> 
> What happens if one uses an older perl version?  A mysterious-looking
> splat, I assume?
> 
> It would be nicer to have some explicit perl version test which tells
> user what the problem is, and which perl version is needed?
> 

There is such a test already.
You Signed-off on it.

commit d62a201f24cba74e2fbf9f6f7af86ff5f5e276fc
Author: Dave Hansen <dave.hansen@linux.intel.com>
Date:   Wed Sep 11 14:23:56 2013 -0700

    checkpatch: enforce sane perl version
    
    I got a bug report from a couple of users who said checkpatch.pl was
    broken for them.  It was erroring out on fairly random lines most commonly
    with messages like:
    
        Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-
    
    The bug reporter was running a version of perl 5.8 which was end-of-lifed
    in 2008: http://www.cpan.org/src/.  Versions of perl this old are at
    _best_ quite untested.  At worst, they are crusty and known to be
    completely broken.
    
    If folks have a system _that_ old, then we should have mercy on them and
    give them a half-decent error message rather than fail with nutty error
    messages.
    
    This patch enforces that checkpatch.pl is run with perl 5.10, which was
    end-of-lifed in 2009.  The new --ignore-perl-version command-line switch
    will let folks override this if they want.
    
    Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: Joe Perches <joe@perches.com>
    Cc: Andy Whitcroft <apw@shadowen.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



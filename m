Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaGGXpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:45:43 -0400
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:58081 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236AbaGGXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:45:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:7652:8599:8603:9025:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12292:12296:12517:12519:12555:12682:12683:12740:13069:13161:13229:13311:13357:13845:14094:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pigs62_6bb3a4ac39c22
X-Filterd-Recvd-Size: 2251
Message-ID: <1404776738.932.10.camel@joe-AO725>
Subject: Re: [PATCH 00/18] lib: bitmap: Various improvements
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Date: Mon, 07 Jul 2014 16:45:38 -0700
In-Reply-To: <20140707162008.e5b2e1446b2266b50182c723@linux-foundation.org>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
	 <20140707162008.e5b2e1446b2266b50182c723@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 16:20 -0700, Andrew Morton wrote:
> On Fri,  4 Jul 2014 00:42:46 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> 
> > Many functions in lib/bitmap.c start with an expression such as lim =
> > bits/BITS_PER_LONG. Since bits has type (signed) int, and since gcc
> > cannot know that it is in fact non-negative, it generates worse code
> > than it could. These patches, mostly consisting of changing various
> > parameters to unsigned, gives a slight overall code reduction:
> 
> Yes, we have a bad habit of using signed types for things where
> negative values are absurd.

Linus at one time wrote:
http://thread.gmane.org/gmane.linux.kernel/1526174

---------------------------------------------------------
The fact is, the x86 bitop instructions act on a
signed index. Making the index be "unsigned long" would violate the
actual *behavior* of the function, so it would be singularly stupid.
---------------------------------------------------------

> The patches look OK to me.

Me too.

But this does have the unfortunate effect of allowing
bitmap tests on bitmaps that are unable to be set/cleared
when the bitmap is larger than INT_MAX size.

There could be some check to make sure size <= INT_MAX.

The docs could be clearer here too about the actual
maximum size of a bitmap.



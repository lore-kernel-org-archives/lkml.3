Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaDNS3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:29:19 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:58213 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750838AbaDNS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:29:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6119:7652:7903:8599:8985:8987:9010:9025:9040:9388:10004:10400:10848:11026:11232:11657:11658:11854:11914:12043:12292:12295:12438:12517:12519:12682:12740:12764:12855:13019:13069:13161:13229:13311:13357:13845:13975,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: level96_167b112123a37
X-Filterd-Recvd-Size: 2260
Message-ID: <1397500153.2962.11.camel@joe-AO722>
Subject: Re: [PATCH 1/1] prefetch result for ARM64 atomic ops
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: catalin.marinas@arm.com, LKML <linux-kernel@vger.kernel.org>, tony@bake
Date: Mon, 14 Apr 2014 11:29:13 -0700
In-Reply-To: <CAJhHMCCPd3+AddjK2S==4jii5G5q7ioNOjJ-0ds0u6YYVeBaoQ@mail.gmail.com>
References: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>
	 <1397498661.2962.5.camel@joe-AO722>
	 <CAJhHMCCPd3+AddjK2S==4jii5G5q7ioNOjJ-0ds0u6YYVeBaoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 14:11 -0400, Pranith Kumar wrote:
> On Mon, Apr 14, 2014 at 2:04 PM, Joe Perches <joe@perches.com> wrote:
> > Are there some benchmark comparison results
> > you neglected to attach?
> 
> I was trying to get these ops to be similar to the 32 bit atomic ops which
> all have prefetch. I did not see any reason why we shouldn't do the same
> here. But no, no hard numbers yet.

Then you should probably send this as an RFC patch.

> >> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
> >> +    prefetchw(&v->counter);
> >
> > Does this compile?

> Argh, my mistake! I overlooked this. Please find fixed patch below:
[]
> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
[]
> @@ -235,6 +244,7 @@ static inline long atomic64_cmpxchg(atomic64_t
> *ptr, long old, long new)
>      unsigned long res;
> 
>      smp_mb();
> +    prefetchw(&v->counter);

It seems you sent the original patch again, still not compiled.

An arm64 cross-compiler is available here:
http://linuxdriverproject.org/mediawiki/index.php/Cross-compiling_Linux_kernel_on_x86_64#Installing_arm64_cross-compiler

It'd be nice if an arm64 toolchain was on the kernel.org list too
https://www.kernel.org/pub/tools/crosstool/




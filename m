Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaDNSEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:04:51 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:36794 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027AbaDNSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:04:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3873:4321:4605:5007:7652:10004:10400:10848:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: road44_607498fd09e0c
X-Filterd-Recvd-Size: 1276
Message-ID: <1397498661.2962.5.camel@joe-AO722>
Subject: Re: [PATCH 1/1] prefetch result for ARM64 atomic ops
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2014 11:04:21 -0700
In-Reply-To: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>
References: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 13:55 -0400, Pranith Kumar wrote:

Are there some benchmark comparison results
you neglected to attach?

> diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
[]
> @@ -235,6 +244,7 @@ static inline long atomic64_cmpxchg(atomic64_t
> *ptr, long old, long new)
>      unsigned long res;
> 
>      smp_mb();
> +    prefetchw(&v->counter);

Does this compile?



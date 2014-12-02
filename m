Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaLBF0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:26:20 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:37576 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaLBF0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:26:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3871:3873:3874:4321:4605:5007:6119:6261:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12296:12438:12517:12519:12555:12740:13019:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: test14_8e1c7ee5a4210
X-Filterd-Recvd-Size: 3227
Message-ID: <1417497975.4894.16.camel@perches.com>
Subject: Re: [PATCH V2 net-next] udp: Neaten and reduce size of
 compute_score functions
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 21:26:15 -0800
In-Reply-To: <1417496925.5303.18.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1417484341.4894.6.camel@perches.com>
	 <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1417489760.4894.8.camel@perches.com>
	 <1417494546.4894.12.camel@perches.com>
	 <1417496925.5303.18.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 21:08 -0800, Eric Dumazet wrote:
> On Mon, 2014-12-01 at 20:29 -0800, Joe Perches wrote:
> > The compute_score functions are a bit difficult to read.
> > 
> > Neaten them a bit to reduce object sizes and make them a
> > bit more intelligible.
> > 
> > Return early to avoid indentation and avoid unnecessary
> > initializations.
> > 
> > (allyesconfig, but w/ -O2 and no profiling)
> 
> hmm... Not sure how you get such large numbers...

Nor I particularly, but I do with gcc 4.9.1

> > $ size net/ipv[46]/udp.o.*
> >    text    data     bss     dec     hex filename
> >   28680    1184      25   29889    74c1 net/ipv4/udp.o.new
> >   28756    1184      25   29965    750d net/ipv4/udp.o.old
[]
> Here I have :
> 
> # size net/ipv4/udp.o.*
>    text	   data	    bss	    dec	    hex	filename
>   21989	    616	      9	  22614	   5856	net/ipv4/udp.o.old
>   21957	    616	      9	  22582	   5836	net/ipv4/udp.o.new

Curious.  What gcc version?

with that 4.9.1 gcc version and a defconfig (x86-64) I get:

$ size net/ipv[46]/udp.o*
   text	   data	    bss	    dec	    hex	filename
  21328	    672	      9	  22009	   55f9	net/ipv4/udp.o.new
  21312	    672	      9	  21993	   55e9	net/ipv4/udp.o.old
  14463	    588	      2	  15053	   3acd	net/ipv6/udp.o.new
  14527	    588	      2	  15117	   3b0d	net/ipv6/udp.o.old

and defconfig x86-32:

$ size net/ipv[46]/udp.o*
   text	   data	    bss	    dec	    hex	filename
  19626	    324	      5	  19955	   4df3	net/ipv4/udp.o.new
  19706	    324	      5	  20035	   4e43	net/ipv4/udp.o.old
  14189	    300	      2	  14491	   389b	net/ipv6/udp.o.new
  14125	    300	      2	  14427	   385b	net/ipv6/udp.o.old

> With CONFIG_CC_OPTIMIZE_FOR_SIZE=y I even have an opposite result (code
> gets bigger after your patch)
> 
> # size net/ipv4/udp.o.*
>    text	   data	    bss	    dec	    hex	filename
>   17242	    600	      9	  17851	   45bb	net/ipv4/udp.o.old
>   17256	    600	      9	  17865	   45c9	net/ipv4/udp.o.new
> 
> Anyway, your patch looks fine to me, no matter what the code size is.
> 
> Acked-by: Eric Dumazet <edumazet@google.com>




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbaLDXfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:35:10 -0500
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:33468 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754776AbaLDXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:35:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3653:3865:3866:3867:3870:3871:3872:3873:4321:4605:5007:6119:6261:6742:8603:10011:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: mine23_f4b8a0169f52
X-Filterd-Recvd-Size: 2253
Message-ID: <1417736103.2721.24.camel@perches.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: Reduce is_ereg() code size
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 15:35:03 -0800
In-Reply-To: <1417734891.22424.2.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CAADnVQKtYkKtsd9rUFm2yfMoh7F_SRFPVP8hpvSY00KpmB-NNg@mail.gmail.com>
	 <1417734048.2721.22.camel@perches.com>
	 <1417734891.22424.2.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 15:14 -0800, Eric Dumazet wrote:
> On Thu, 2014-12-04 at 15:00 -0800, Joe Perches wrote:
> > Use the (1 << reg) & mask trick to reduce code size.
[]
> Really, the root cause of this is the 'inline' abuse in non fast paths
> for non trivial functions.

There is no object size change with is_ereg()
defined "static inline" or "static"

Curiously, if you mark it noinline, the size increases.

gcc 4.9.1, x86-64, -O2 no profiling support

$ size arch/x86/net/bpf_jit_comp.o.st*
   text	   data	    bss	    dec	    hex	filename
  10679	      4	      0	  10683	   29bb	arch/x86/net/bpf_jit_comp.o.static_inline
  11535	      4	      0	  11539	   2d13	arch/x86/net/bpf_jit_comp.o.static_noinline
  10679	      4	      0	  10683	   29bb	arch/x86/net/bpf_jit_comp.o.static_without_inline



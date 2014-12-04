Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaLDJ0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:26:35 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:55489 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752526AbaLDJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:26:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:4321:4605:5007:6119:6261:6742:8603:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steel14_1b7c37cf6343b
X-Filterd-Recvd-Size: 1965
Message-ID: <1417685187.2721.1.camel@perches.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Joe Perches <joe@perches.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 01:26:27 -0800
In-Reply-To: <1417114175.4305.3.camel@perches.com>
References: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com>
	 <1417032059.16355.4.camel@perches.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
	 <1417114175.4305.3.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 10:49 -0800, Joe Perches wrote:
> On Thu, 2014-11-27 at 12:25 +0000, David Laight wrote:
> > Why the change in data?
> 
> btw: without gcov and using -O2
> 
> $ size arch/x86/net/bpf_jit_comp.o*
>    text	   data	    bss	    dec	    hex	filename
>    9671	      4	      0	   9675	   25cb	arch/x86/net/bpf_jit_comp.o.new
>   10679	      4	      0	  10683	   29bb	arch/x86/net/bpf_jit_comp.o.old

Alexei?

Is this 10% reduction in size a good reason to change the code?


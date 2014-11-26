Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKZQ6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:58:38 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:35330 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753233AbaKZQ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:58:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6119:6261:6742:7514:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bait31_ff5f840e6f1e
X-Filterd-Recvd-Size: 2603
Message-ID: <1417021108.19695.5.camel@perches.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Joe Perches <joe@perches.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2014 08:58:28 -0800
In-Reply-To: <CAADnVQK8mn4ZHwbhBArosEw3Bmsc5vJfOzAeRE3R_1S7dbNfkg@mail.gmail.com>
References: <CAADnVQK8mn4ZHwbhBArosEw3Bmsc5vJfOzAeRE3R_1S7dbNfkg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 08:42 -0800, Alexei Starovoitov wrote:
> On Wed, Nov 26, 2014 at 1:18 AM, Quentin Lambert
> <lambert.quentin@gmail.com> wrote:
> > Remove if then else statements preceding
> > boolean return.
[]
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
[]
> > @@ -135,11 +135,9 @@ static const int reg2hex[] = {
> >   */
> >  static inline bool is_ereg(u32 reg)
> >  {
> > -       if (reg == BPF_REG_5 || reg == AUX_REG ||
> > -           (reg >= BPF_REG_7 && reg <= BPF_REG_9))
> > -               return true;
> > -       else
> > -               return false;
> > +       return (reg == BPF_REG_5 ||
> > +               reg == AUX_REG ||
> > +               (reg >= BPF_REG_7 && reg <= BPF_REG_9));
> 
> please remove extra () around the whole expression, and
> align in properly, and
> don't move reg==AUX_REG check to a different line.
> Subject is not warranted. I don't think it's a simplification.

It's not really a simplification,
gcc should emit the same object code.

> imo existing code is fine and I don't think the time spent
> reviewing such changes is worth it when there is no
> improvement in readability.

Is there any value in reordering these tests for frequency
or maybe using | instead of || to avoid multiple jumps?



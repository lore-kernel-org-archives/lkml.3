Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3FZPhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:37:18 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:48042
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab3FZPhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:37:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP0BDW-01-DPM-02
X-M-MSG: 
Date: Wed, 26 Jun 2013 10:37:06 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130626153706.GA8253@jshin-Toonie>
References: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
 <20130612193119.GB15934@jshin-Toonie>
 <20130620103053.GA9609@gmail.com>
 <20130620151616.GA2045@jshin-Toonie>
 <20130620152414.GA6676@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130620152414.GA6676@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:24:14AM -0500, Jacob Shin wrote:
> On Thu, Jun 20, 2013 at 10:16:16AM -0500, Jacob Shin wrote:
> > On Thu, Jun 20, 2013 at 12:30:53PM +0200, Ingo Molnar wrote:
> > > 
> > > * Jacob Shin <jacob.shin@amd.com> wrote:
> > > 
> > > > On Fri, Jun 07, 2013 at 09:22:18PM -0500, Jacob Shin wrote:
> > > > > This patchset addreses two problems with early loading on AMD.
> > > > > 
> > > > > First, feedback from Yinghai that find_ucode_in_initrd() should be
> > > > > marked __init:
> > > > >   https://lkml.org/lkml/2013/6/4/695
> > > > > 
> > > > > And second, feedback from Henrique that Intel early loading supports
> > > > > multiple microcode firmware concatenated together, whereas the current
> > > > > AMD implementation lacks this support:
> > > > >   https://lkml.org/lkml/2013/5/31/4
> > > > > 
> > > > > V3:
> > > > > * style fix -- reduce multiple if statements into a single one
> > > > 
> > > > Hi hpa or Yinghai, just wondering if you had the chance to look at this
> > > > V3 yet.
> > > 
> > > It appears Peter applied v2 to tip:x86/microcode two days before you sent 
> > > v3 - please send any changes in v3 as delta patches.
> > 
> > I actually recieved the tip-bot email <https://lkml.org/lkml/2013/6/12/468>
> > couple of days after sending out the above message, so I assumed that
> > V3 was committed in.
> > 
> > I should have read the tip-bot message thoroughly and noticed
> > it. Sorry about that. Here is the delta patch:
> 
> Sigh :-( .. sorry, forgot to sign off. Here it is again:
> 
> ---8<---
> 
> From 1445587da716b306f39feef46fb7150f292060c7 Mon Sep 17 00:00:00 2001
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Thu, 20 Jun 2013 09:52:50 -0500
> Subject: [PATCH] x86, microcode, amd: another early loading fixup
> 
> commit cd1c32ca969ebfd65e61312c988223bb14f09c2e is an early premature
> rendition of the patch. Augment it with this delta patch to:
>   * correctly mark offset and size of the matching bin file
>   * use __pa instead of __pa_nodebug during AP load
>   * check for !initrd_start before using it
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Hi hpa, checking back to see if you had the chance to look at this
delta patch. It is needed to properly support concatenated microcode
binaries on AMD early load. (Intel already supports this).

Thank you,


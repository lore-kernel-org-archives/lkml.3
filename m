Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823AbaKNApt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:45:49 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:42400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933889AbaKNApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:45:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1543:1593:1594:1605:1711:1730:1747:1777:1792:2110:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4384:4605:4641:5007:6119:6120:6248:6261:6691:7808:7903:9010:9025:10004:10226:10400:10848:11026:11232:11473:11658:11914:12043:12050:12214:12291:12438:12517:12519:12555:12663:12740:13095:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steel64_898ae260b7222
X-Filterd-Recvd-Size: 5030
Message-ID: <1415925943.4141.1.camel@perches.com>
Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 13 Nov 2014 16:45:43 -0800
In-Reply-To: <20141114001720.GD4042@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
	 <20141030120127.GC32589@arm.com>
	 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
	 <20141030135749.GE32589@arm.com>
	 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
	 <20141113235322.GC4042@n2100.arm.linux.org.uk>
	 <1415923530.4223.17.camel@perches.com>
	 <20141114001720.GD4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 00:17 +0000, Russell King - ARM Linux wrote:
> On Thu, Nov 13, 2014 at 04:05:30PM -0800, Joe Perches wrote:
> > On Thu, 2014-11-13 at 23:53 +0000, Russell King - ARM Linux wrote:
> > > On Fri, Oct 31, 2014 at 01:42:44PM +0800, Wang, Yalin wrote:
> > > > This patch add bitrev.h file to support rbit instruction,
> > > > so that we can do bitrev operation by hardware.
> > > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > > > ---
> > > >  arch/arm/Kconfig              |  1 +
> > > >  arch/arm/include/asm/bitrev.h | 21 +++++++++++++++++++++
> > > >  2 files changed, 22 insertions(+)
> > > >  create mode 100644 arch/arm/include/asm/bitrev.h
> > > > 
> > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > index 89c4b5c..be92b3b 100644
> > > > --- a/arch/arm/Kconfig
> > > > +++ b/arch/arm/Kconfig
> > > > @@ -28,6 +28,7 @@ config ARM
> > > >  	select HANDLE_DOMAIN_IRQ
> > > >  	select HARDIRQS_SW_RESEND
> > > >  	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
> > > > +	select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
> > > 
> > > Looking at this, this is just wrong.  Take a moment to consider what
> > > happens if we build a kernel which supports both ARMv6 _and_ ARMv7 CPUs.
> > > What happens if an ARMv6 CPU tries to execute an rbit instruction?
> > > 
> > > Second point (which isn't obvious from your submissions on-list) is that
> > > you've loaded the patch system up with patches for other parts of the
> > > kernel tree for which I am not responsible for.  As such, I can't take
> > > those patches without the sub-tree maintainer acking them.  Also, the
> > > commit text in those patches look weird:
> > > 
> > > 6fire: Convert byte_rev_table uses to bitrev8
> > > 
> > > Use the inline function instead of directly indexing the array.
> > > 
> > > This allows some architectures with hardware instructions for bit
> > > reversals to eliminate the array.
> > > 
> > > Signed-off-by: Joe Perches <(address hidden)>
> > > Signed-off-by: Yalin Wang <(address hidden)>
> > > 
> > > Why is Joe signing off on these patches?
> > > Shouldn't his entry be an Acked-by: ?
> > 
> > I didn't sign off on or ack the "add bitrev.h" patch.
> 
> Correct, I never said you did.  Please read my message a bit more carefully
> next time, huh?

You've no reason to write that Russell.

I'm not trying to be anything other than clear and no I
didn't say you said that either.

Why not make your own writing clearer or your own memory
sharper then eh?  Reply on the patch I actually wrote.
You were cc'd on it when I submitted it.

> > I created 2 patches that converted direct uses of byte_rev_table
> > to that bitrev8 static inline.  One of them is already in -next
> > 
> > 7a1283d8f5298437a454ec477384dcd9f9f88bac carl9170: Convert byte_rev_table uses to bitrev8
> > 
> > The other hasn't been applied.
> > 
> > https://lkml.org/lkml/2014/10/28/1056
> > 
> > Maybe Takashi Iwai will get around to it one day.
> 
> Great, so I can just discard these that were incorrectly submitted to me
> then.

I think you shouldn't apply these patches or updated
ones either until all the current uses are converted.

cheers, Joe


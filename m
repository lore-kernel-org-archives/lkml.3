Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162AbaKNBSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:18:52 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38941 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934547AbaKNBSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:18:49 -0500
Date: Fri, 14 Nov 2014 01:18:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Message-ID: <20141114011832.GE4042@n2100.arm.linux.org.uk>
References: <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <1415923530.4223.17.camel@perches.com>
 <20141114001720.GD4042@n2100.arm.linux.org.uk>
 <1415925943.4141.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415925943.4141.1.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 04:45:43PM -0800, Joe Perches wrote:
> On Fri, 2014-11-14 at 00:17 +0000, Russell King - ARM Linux wrote:
> > On Thu, Nov 13, 2014 at 04:05:30PM -0800, Joe Perches wrote:
> > > On Thu, 2014-11-13 at 23:53 +0000, Russell King - ARM Linux wrote:
> > > > On Fri, Oct 31, 2014 at 01:42:44PM +0800, Wang, Yalin wrote:
> > > > > This patch add bitrev.h file to support rbit instruction,
> > > > > so that we can do bitrev operation by hardware.
> > > > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > > > > ---
> > > > >  arch/arm/Kconfig              |  1 +
> > > > >  arch/arm/include/asm/bitrev.h | 21 +++++++++++++++++++++
> > > > >  2 files changed, 22 insertions(+)
> > > > >  create mode 100644 arch/arm/include/asm/bitrev.h
> > > > > 
> > > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > > index 89c4b5c..be92b3b 100644
> > > > > --- a/arch/arm/Kconfig
> > > > > +++ b/arch/arm/Kconfig
> > > > > @@ -28,6 +28,7 @@ config ARM
> > > > >  	select HANDLE_DOMAIN_IRQ
> > > > >  	select HARDIRQS_SW_RESEND
> > > > >  	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
> > > > > +	select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
> > > > 
> > > > Looking at this, this is just wrong.  Take a moment to consider what
> > > > happens if we build a kernel which supports both ARMv6 _and_ ARMv7 CPUs.
> > > > What happens if an ARMv6 CPU tries to execute an rbit instruction?
> > > > 
> > > > Second point (which isn't obvious from your submissions on-list) is that
> > > > you've loaded the patch system up with patches for other parts of the
> > > > kernel tree for which I am not responsible for.  As such, I can't take
> > > > those patches without the sub-tree maintainer acking them.  Also, the
> > > > commit text in those patches look weird:
> > > > 
> > > > 6fire: Convert byte_rev_table uses to bitrev8
> > > > 
> > > > Use the inline function instead of directly indexing the array.
> > > > 
> > > > This allows some architectures with hardware instructions for bit
> > > > reversals to eliminate the array.
> > > > 
> > > > Signed-off-by: Joe Perches <(address hidden)>
> > > > Signed-off-by: Yalin Wang <(address hidden)>
> > > > 
> > > > Why is Joe signing off on these patches?
> > > > Shouldn't his entry be an Acked-by: ?
> > > 
> > > I didn't sign off on or ack the "add bitrev.h" patch.
> > 
> > Correct, I never said you did.  Please read my message a bit more carefully
> > next time, huh?
> 
> You've no reason to write that Russell.

Absolutely I have, but I'm not going to discuss it because I'll just
end up flaming you because in my mind you are the one who is completely
mistaken with your comments.

In case it hasn't been realised, I hardly read this mailing list anymore,
or messages that I'm Cc'd on.  I do read most messages that I'm in the
To: line, but generally not if they're DT changes (which always end up
being marked To: me.)

> > Great, so I can just discard these that were incorrectly submitted to me
> > then.
> 
> I think you shouldn't apply these patches or updated
> ones either until all the current uses are converted.

Where are the dependencies mentioned?  How do I get to know when all
the dependencies are met?  Who is tracking the dependencies?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

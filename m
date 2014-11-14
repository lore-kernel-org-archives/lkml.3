Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbaKNCBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:01:39 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:12020 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933518AbaKNCBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:01:38 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 14 Nov 2014 10:01:34 +0800
Subject: RE: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Index: Ac//nQoUxyiR4A/+S1KTxThngzC6WQAET/GA
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1829B@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141113235322.GC4042@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Friday, November 14, 2014 7:53 AM
> To: Wang, Yalin
> > On Fri, Oct 31, 2014 at 01:42:44PM +0800, Wang, Yalin wrote:
> > This patch add bitrev.h file to support rbit instruction, so that we
> > can do bitrev operation by hardware.
> > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > ---
> >  arch/arm/Kconfig              |  1 +
> >  arch/arm/include/asm/bitrev.h | 21 +++++++++++++++++++++
> >  2 files changed, 22 insertions(+)
> >  create mode 100644 arch/arm/include/asm/bitrev.h
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig index
> > 89c4b5c..be92b3b 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -28,6 +28,7 @@ config ARM
> >  	select HANDLE_DOMAIN_IRQ
> >  	select HARDIRQS_SW_RESEND
> >  	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
> > +	select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
> 
> Looking at this, this is just wrong.  Take a moment to consider what
> happens if we build a kernel which supports both ARMv6 _and_ ARMv7 CPUs.
> What happens if an ARMv6 CPU tries to execute an rbit instruction?

Is it possible to build a kernel that support both CPU_V6 and CPU_V7?
I mean in Kconfig, CPU_V6 = y and CPU_V7 = y ?
If there is problem like you said,
How about this solution:
select HAVE_ARCH_BITREVERSE if ((CPU_V7M || CPU_V7) && !CPU_V6)  


> Second point (which isn't obvious from your submissions on-list) is that
> you've loaded the patch system up with patches for other parts of the
> kernel tree for which I am not responsible for.  As such, I can't take
> those patches without the sub-tree maintainer acking them.  Also, the
> commit text in those patches look weird:
> 
> 6fire: Convert byte_rev_table uses to bitrev8
> 
> Use the inline function instead of directly indexing the array.
> 
> This allows some architectures with hardware instructions for bit reversals
> to eliminate the array.
> 
> Signed-off-by: Joe Perches <(address hidden)>
> Signed-off-by: Yalin Wang <(address hidden)>
> 
> Why is Joe signing off on these patches?  As his is the first sign-off, one
> assumes that he was responsible for creating the patch in the first place,
> but there is no From: line marking him as the author.  Shouldn't his entry
> be an Acked-by: ?
> 
> Confused.
For this patch,
I just cherry-pick from Joe,
If you are not responsible for this part,
I will submit to the maintainers for these patches .
Sorry for that .


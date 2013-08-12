Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3HLVWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:22:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41270 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:22:10 -0400
Date: Mon, 12 Aug 2013 22:21:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130812212149.GH23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk> <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com> <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com> <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:49:54PM +0100, Peter Maydell wrote:
> On 12 August 2013 21:06, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Aug 12, 2013 at 06:33:28PM +0100, Peter Maydell wrote:
> >>     /* Slot to IRQ mapping for RealView EB and PB1176 backplane
> >>      *      name    slot    IntA    IntB    IntC    IntD
> >>      *      A       31      IRQ50   IRQ51   IRQ48   IRQ49
> >>      *      B       30      IRQ49   IRQ50   IRQ51   IRQ48
> >>      *      C       29      IRQ48   IRQ49   IRQ50   IRQ51
> >>      * Slot C is for the host bridge; A and B the peripherals.
> >>      * Our output irqs 0..3 correspond to the baseboard's 48..51.
> >>      */
> >>
> >> ie IRQ48 == board's PCI0 == slot C connector A6 (IntA) == PCI_nINTB
> >>    == Slot B connector B8 (IntD) == Slot A connector A7 (IntC).
> >>
> >> and so on round.
> >>
> >> The 926's routing is one extra round of swizzling because the
> >> board itself connects FPGA P_nINTA to its edge connector's
> >> INTB (B7) pin rather than INTA (A6) as the EB/1176 do.
> >> (This isn't even hinted at in the documentation, you need to
> >> either experiment or look at the 926 board schematic.)
> >
> > Okay, so the above just adds to the confusion, because you appear to be
> > mistaking "slot" for the AD signal which the IDSEL pin is connected to.
> 
> The board TRM:
> http://infocenter.arm.com/help/topic/com.arm.doc.dui0411d/Cacdijji.html
> says that "slot position" and "AD signal connected to IDSEL"
> are the same thing:

That's realview, not versatile.  Are you saying that both are exactly
the same wrt this?

> I don't currently have the h/w set up, but digging in my email
> archives, when we were running the kernel on the real PB926
> h/w and backplane it was indeed reporting the PCI core (ie
> "slot C") as 29, and the other two as 30 and 31:
> [  128.920150] PCI core found (slot 29)
> [  128.920875] pci 0000:00:1f.0: reg 10: [io  0x0af0-0x0aff]
> [  128.920958] pci 0000:00:1f.0: reg 14: [io  0x0a70-0x0a7f]
> [  128.921032] pci 0000:00:1f.0: reg 18: [io  0x01f0-0x01ff]
> [  128.921103] pci 0000:00:1f.0: reg 1c: [io  0x0170-0x017f]
> [  128.921173] pci 0000:00:1f.0: reg 20: [io  0xcc00-0xcc1f]
> [  128.921244] pci 0000:00:1f.0: reg 24: [io  0x8c00-0x8cff]
> [  128.921320] pci 0000:00:1f.0: reg 30: [mem 0xffff0000-0xffffffff pref]

With realview or versatile?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab3HOSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:39:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43361 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3HOSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:39:04 -0400
Date: Thu, 15 Aug 2013 11:39:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130815183904.GA4067@roeck-us.net>
References: <5207B3C3.9080508@roeck-us.net>
 <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net>
 <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130813034054.GA18218@roeck-us.net>
 <CAFEAcA_-S8z6ZMr8TMPvkcTyyCSMOj1DExVsY4JDQjRXDU5WGw@mail.gmail.com>
 <20130815175428.GA18580@roeck-us.net>
 <CAFEAcA_MyJPwo6Gd_dxeWM5q5-7MYqR6-rrePusFzYaGGckWJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA_MyJPwo6Gd_dxeWM5q5-7MYqR6-rrePusFzYaGGckWJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:05:22PM +0100, Peter Maydell wrote:
> On 15 August 2013 18:54, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Thu, Aug 15, 2013 at 05:45:42PM +0100, Peter Maydell wrote:
> >> On 13 August 2013 04:40, Guenter Roeck <linux@roeck-us.net> wrote:
> >> > Patch tested and working with qemu 1.5.2, using the configuration file
> >> > from the yocto project. Patch applied on top of kernel version 3.11-rc5.
> >>
> >> OK, I tested this on PB926+PCI backplane hardware, and it is
> >> definitely better than current mainline, in that the test USB
> >> card that I have no longer causes the kernel to generate this sort of
> >> backtrace:
> >>
> > Do you mean my patch fixes the traceback below as a side effect ?
> > Would be great ... it would be one more reason to get it applied.
> 
> Yes, exactly -- the kernel currently has the wrong irq mapping,
> which causes the traceback (ie h/w asserts irq 93 but the kernel
> is listening on something else). That the patch fixes this confirms
> that it is the behaviour of hardware as well as of QEMU.
> 
> >> However it still doesn't seem to reliably detect the USB harddisk
> >> plugged into the card, so I think there may be further issues, possibly
> >> some subset of those Arnd identified and fixed with this patch:
> >> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/93397
> >>
> > Does it get better if you apply Arnd's patch ?
> 
> Arnd's patch is ancient and won't apply as is (due to intervening
> changes and also because some of the things it fixes were fixed
> in later patches); I'm currently trying to extract the relevant parts.
> 
> If you want you can confirm that I/O port PCI access is broken on
> QEMU too -- disable CONFIG_SCSI_SYM53C8XX_MMIO so
> the driver uses PCI IO rather than MMIO and you'll see QEMU's
> SCSI device doesn't work any more.
> 
> >> so I'd like to continue testing.
> >>
> >> The other thing this patch should (IMHO) have is the
> >> line in pci_versatile_setup() which tells QEMU that the
> >> kernel really does expect hardware-like behaviour:
> 
> >> (Without this line QEMU will guess whether the kernel is broken
> >> or not and will get it right most but not necessarily all of the time.)
> >>
> > Might make sense, but I think it should be a separate patch.
> 
> It needs to go in the same patch, because a kernel with the fixed
> irq remapping must also tell QEMU it is fixed; if you split the
> two then at the point between the two patches the kernel is
> broken for bisection purposes.
> 
> > If I understand correctly, my patch fixes the SCSI problem.
> > Is that correct ? If so, can we get it applied to mainline ?
> 
> I'd rather get to a point where I have the hardware definitely
> completely working first. There's no real hurry, this has been
> broken for months and months.
> 
Ok with me, if it doesn't get lost.

Until it gets fixed, arm status on 3.10 kernels will show as "failed"
for qemu test runs.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbaGRJDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:03:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37861 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760842AbaGRJDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:03:02 -0400
Date: Fri, 18 Jul 2014 10:02:05 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Message-ID: <20140718090204.GB25180@leverpostej>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140717131854.GN13108@titan.lakedaemon.net>
 <20140717135534.GM30313@leverpostej>
 <20140717141235.GR13108@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717141235.GR13108@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 03:12:35PM +0100, Jason Cooper wrote:
> On Thu, Jul 17, 2014 at 02:55:34PM +0100, Mark Rutland wrote:
> > Hi Jason,
> > 
> > On Thu, Jul 17, 2014 at 02:18:54PM +0100, Jason Cooper wrote:
> > > On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
> > > > From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> > > > 
> > > > This patch set introduces support for MSI(-X) in GICv2m specification,
> > > > which is implemented in some variation of GIC400.
> > > > 
> > > > This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
> > > > (https://lkml.org/lkml/2014/3/14/320).
> > > > 
> > > > Changes in V3:
> > > >     * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic
> > > >       (per Jason Cooper request)
> > > >     * Misc fix/clean up per Mark Rutland comments
> > > >     * Minor Clean up in the driver/irqchip/irq-gic-v2m.c: alloc_msi_irqs()
> > > >     * Patch 4 is new to the series:
> > > >         * Add ARM64-specific version arch_setup_msi_irqs() to allow support
> > > >           for Multiple MSI.
> > > >         * Add support for Multiple MSI for GICv2m.
> > > > 
> > > > Suravee Suthikulpanit (4):
> > > >   irqchip: gic: Add binding probe for ARM GIC400
> > > >   irqchip: gic: Restructuring ARM GIC code
> > > >   irqchip: gic: Add supports for ARM GICv2m MSI(-X)
> > > >   irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
> > > 
> > > Ok, patch #1 applied to irqchip/urgent.  Patches 2 and 3 applied to
> > > irqchip/gic with irqchip/urgent merged in.  To facilitate
> > > testing/merging, I've prepared an unsigned tag for you on the
> > > irqchip/gic branch:
> > 
> > I'm a little concerned that this is all going through for v3.17 without
> > a {Reviewed,Acked}-by from Marc or anyone working with GIC{,v2m}.
> 
> Well, that's why it's not in irqchip/core yet. ;-)  It can be undone if
> needed.

Ah, perhaps I was a litte premature. :)
 
> > While his comments on v1 have been addressed, he has not had a chance to
> > acknowledge the solutions. I appreciate Marc's holiday is unfortunately
> > timed.
> > 
> > I also have an open concern with the binding with regard to the
> > orthogonality of GICV GICH and the MSI registers.
> > 
> > Suravee, do you need this urgently for v3.17? I was under the impression
> > that we wouldn't have full PCIe support by then.
> 
> If Suravee is ok with it, I can drop them for now and he can resend for
> v3.18.  Since we've worked out a way to merge it all in one window, I
> don't think it would hurt anything to wait.

Ok.

> I'll leave these in irqchip/for-next until I hear from Suravee, then
> I'll drop the lot till we hear from Marc and look at the timing.

Keeping it in for-next for testing sounds like a good idea, but until we
hear from Marc I wouldn't want to see this queued for mainline. So the
above sounds fine to me.

Cheers,
Mark.

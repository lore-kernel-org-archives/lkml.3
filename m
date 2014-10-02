Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaJBFWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 01:22:21 -0400
Received: from ozlabs.org ([103.22.144.67]:36321 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaJBFWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 01:22:20 -0400
Message-ID: <1412227337.6143.0.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 06/17] powerpc/powernv: Split out set MSI IRQ chip
 code
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 15:22:17 +1000
In-Reply-To: <20141002015729.D379414016B@ozlabs.org>
References: <20141002015729.D379414016B@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 11:57 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:55 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > Some of the MSI IRQ code in pnv_pci_ioda_msi_setup() is generically useful so
> > split it out.
> > 
> > This will be used by some of the cxl PCIe code later.
> > 
> > diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> > index df241b1..329164f 100644
> > --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> > +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> > @@ -1306,14 +1306,36 @@ static void pnv_ioda2_msi_eoi(struct irq_data *d)
> >  	icp_native_eoi(d);
> >  }
> >  
> > +
> > +static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
> > +{
> > +	struct irq_data *idata;
> > +	struct irq_chip *ichip;
> > +
> > +	if (phb->type != PNV_PHB_IODA2)
> > +		return;
> > +
> > +	/*
> > +	 * Change the IRQ chip for the MSI interrupts on PHB3.
> > +	 * The corresponding IRQ chip should be populated for
> > +	 * the first time.
> 
> Seeing as you're moving this comment can you clarify the wording.

Ok.

Mikey

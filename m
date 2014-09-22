Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaIVEbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:31:53 -0400
Received: from ozlabs.org ([103.22.144.67]:57553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaIVEbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:31:52 -0400
Message-ID: <1411360310.984.7.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 05/15] powerpc/powernv: Split out set MSI IRQ chip code
From: Michael Neuling <mikey@neuling.org>
To: Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Date: Mon, 22 Sep 2014 14:31:50 +1000
In-Reply-To: <20140919065412.GA27190@shangw>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-6-git-send-email-mikey@neuling.org>
	 <20140919065412.GA27190@shangw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
> >+{
> >+	struct irq_data *idata;
> >+	struct irq_chip *ichip;
> >+
> >+	/*
> >+	 * Change the IRQ chip for the MSI interrupts on PHB3.
> >+	 * The corresponding IRQ chip should be populated for
> >+	 * the first time.
> >+	 */
> >+	if (phb->type == PNV_PHB_IODA2) {
> >+		if (!phb->ioda.irq_chip_init) {
> >+			idata = irq_get_irq_data(virq);
> >+			ichip = irq_data_get_irq_chip(idata);
> >+			phb->ioda.irq_chip_init = 1;
> >+			phb->ioda.irq_chip = *ichip;
> >+			phb->ioda.irq_chip.irq_eoi = pnv_ioda2_msi_eoi;
> >+		}
> >+
> >+		irq_set_chip(virq, &phb->ioda.irq_chip);
> >+	}
> >+}
> >+
> 
> Nitpick: to check PHB type and bail early could avoid nested code :)
> 
> 	if (phb->type != PNV_PHB_IODA2)
> 		return;

OK, will do in repost.

Thanks,
Mikey


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaKLQoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:44:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:42501 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaKLQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:44:00 -0500
Date: Wed, 12 Nov 2014 17:43:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 16/16] PCI/MSI: Enhance core to support hierarchy
 irqdomain
In-Reply-To: <54637CCF.6020501@arm.com>
Message-ID: <alpine.DEB.2.11.1411121743170.3935@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134121.196562300@linutronix.de> <54637CCF.6020501@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Marc Zyngier wrote:
> > +#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
> > +void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
> > +{
> > +	struct msi_desc *desc = irq_data->msi_desc;
> > +
> > +	/*
> > +	 * MSI-X message is written per-IRQ.
> > +	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
> > +	 */
> > +	if (desc->irq == irq_data->irq)
> > +		pci_write_msi_msg(desc, msg);
> 
> My compiler barks at this. Shouldn't that be either:
> 		pci_write_msi_msg(desc->irq, msg);
> or
> 		__pci_write_msi_msg(desc, msg);

The latter.

Thanks,

	tglx

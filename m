Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaGHNbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:31:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45412 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaGHNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:31:30 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-9e-53bbf2b03c7c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
 <1404164720-11066-4-git-send-email-m-karicheri2@ti.com>
 <53BBF031.5080105@ti.com>
In-reply-to: <53BBF031.5080105@ti.com>
Subject: Re: [PATCH v3 3/5] PCI: designware: refactor host init code to re-use
 on keystone PCI
Date: Tue, 08 Jul 2014 22:31:27 +0900
Message-id: <001301cf9ab0$ebb8c470$c32a4d50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+ar5NnmeQEmecZQrWHjbOu3NfOHAAABuOw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t8zQ90Nn3YHGzSu47X4O+kYu8WSpgyL
	l4c0LeYfOcdq0f9mIavFgT87GC3OvVrJaHF54SVWiwtPe9gsLu+aw2Zxdt5xNovbl3kt+noP
	sFm8aWtktFh6/SKTxcapvxgtJkxfy2LRfknZ4vEsYYu3d6azWLTuPcJu8bpvDbODmMeaeWsY
	PVqae9g8fv+axOhxua+XyWPerBMsHv8O9zN5LNhU6rFy+Rc2j80rtDw2repk87hzbQ+bR9+W
	VYweT3/sZfY4fmM7k8fnTXIB/FFcNimpOZllqUX6dglcGU+6bQt+ulbsPjGdtYHxv1kXIyeH
	hICJRM+G/6wQtpjEhXvr2boYuTiEBJYxSjyZNIcRpmjl7NMsEIlFjBIP/j6Ccn4zSnStuQVW
	xSagJvHly2F2EFtEIECi5VQfI0gRs8AjVoknx1pYITpmMkrMuTUVrIoTqOPx248sILawQILE
	m/VHwGwWAVWJf7/ng03lFbCVWP15MzOELSjxY/I9sBpmAS2J9TuPM0HY8hKb17wFquEAulVd
	4tFfXYgjjCTajv6AKhGR2PfiHdhBEgKTOSUO33zODLFLQOLb5EMsEL2yEpsOMEO8LClxcMUN
	lgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIsurdwXj7
	gPUhxmSg9ROZpUST84HJLq8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGFcxK3OoLF/SxFt2v3YZz+nPvQ1bvQVvOBVt3bi5vXV7stBVM896H/ON
	go/YGeYu52Y5NXuHtpfrSes4I7YDIg+1TnR8djZfz6yz22jPsuLpJTIPutu8tnysd6neVcZz
	/voe0TSX158YmA51zd6wVsOh537MWy1BhkNBDDk+bME35Iyn7MsrVGIpzkg01GIuKk4EAH6O
	c7hsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42I5/e+xgO6GT7uDDdbuZbP4O+kYu8WSpgyL
	l4c0LeYfOcdq0f9mIavFgT87GC3OvVrJaHF54SVWiwtPe9gsLu+aw2Zxdt5xNovbl3kt+noP
	sFm8aWtktFh6/SKTxcapvxgtJkxfy2LRfknZ4vEsYYu3d6azWLTuPcJu8bpvDbODmMeaeWsY
	PVqae9g8fv+axOhxua+XyWPerBMsHv8O9zN5LNhU6rFy+Rc2j80rtDw2repk87hzbQ+bR9+W
	VYweT3/sZfY4fmM7k8fnTXIB/FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QN8rKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnr
	GDOedNsW/HSt2H1iOmsD43+zLkZODgkBE4mVs0+zQNhiEhfurWfrYuTiEBJYxCjx4O8jFgjn
	N6NE15pbjCBVbAJqEl++HGYHsUUEAiRaTvUxghQxCzxilXhyrIUVomMmo8ScW1PBqjiBOh6/
	/Qi2Q1ggQeLN+iNgNouAqsS/3/PBpvIK2Eqs/ryZGcIWlPgx+R5YDbOAlsT6nceZIGx5ic1r
	3gLVcADdqi7x6K8uxBFGEm1Hf0CViEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUgu
	KE5KzzXUK07MLS7NS9dLzs/dxAhOhc+kdjCubLA4xCjAwajEw7vi4K5gIdbEsuLK3EOMEhzM
	SiK8X07tDhbiTUmsrEotyo8vKs1JLT7EaAr06ERmKdHkfGCaziuJNzQ2MTOyNDKzMDIxN1cS
	5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwBhlME/RaHrk6zPHcxsK6/i2bZtyIcvhKdPjCYsn
	O5ocns75TcRd1VlVjuWd3A79nw/tz66UqMxaufLWywLHWel9aWX8Oc2mwuy+EfrFAsc6379c
	0yBam3Xoz0nH3UeqWnteqr1c/LPPXXSZYr7xlJ70RLHFiWWNYmfNd4SmbRVdOeGTQ+53fyWW
	4oxEQy3mouJEAMTOE8abAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 10:21 PM, Murali Karicheri wrote:
> 
> Mohit, Jingoo,
> 
> Thanks for the Ack for 1/5 and 2/5 of this series.
> 
> Could you also review 3/5 and 4/5 of this series and provide your Ack or
> comments at the earliest.

Sorry, I cannot review 3/5 and 4/5.

For a few years, I have done mainline work without any payment,
as other hobbyists have done. It means that it is very hard to
spend reviewing the patch from mailing list. Currently, I am up to
my neck in work. In the case of 3/5 and 4/5 of your patchset,
it requires me to spend a lot of time.

I will go the extra miles to review all patches including your
patches. But, I am not sure that I can do it. Thank you.

Best regards,
Jingoo Han
> 
> Thanks and regards,
> 
> Murali
> 
> On 06/30/2014 05:45 PM, Murali Karicheri wrote:
> > This patch refactor the host controller init code to support Keystone
> > PCI controller.
> >
> > Current DW PCI host controller init code has code specific to newer
> > DW hw such as ATU port resource parse and ioremap. Conditionally
> > execute this code if DW h/w is not v3.65. Keystone PCI controller
> > is based on v3.65 DW PCI h/w and it has MSI controller implemented
> > in application space and requires different controller initialization
> > code. So factor out the MSI host init code to a separate function.
> >
> > Rename dw_pcie_host_init() to dw_pcie_common_host_init() that takes an
> > additional arg, ptr to hw_pci structure. This allows to re-use the code
> > for Keystone PCI that can now provide it's own pci hw ops and msi irq
> > ops.  dw_pcie_host_init() is now a wrapper function that calls
> > dw_pcie_common_host_init() for pci common initialization.
> >
> > Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> >
> > CC: Santosh Shilimkar<santosh.shilimkar@ti.com>
> > CC: Russell King<linux@arm.linux.org.uk>
> > CC: Grant Likely<grant.likely@linaro.org>
> > CC: Rob Herring<robh+dt@kernel.org>
> > CC: Mohit Kumar<mohit.kumar@st.com>
> > CC: Jingoo Han<jg1.han@samsung.com>
> > CC: Bjorn Helgaas<bhelgaas@google.com>
> > CC: Pratyush Anand<pratyush.anand@st.com>
> > CC: Richard Zhu<r65037@freescale.com>
> > CC: Kishon Vijay Abraham I<kishon@ti.com>
> > CC: Marek Vasut<marex@denx.de>
> > CC: Arnd Bergmann<arnd@arndb.de>
> > CC: Pawel Moll<pawel.moll@arm.com>
> > CC: Mark Rutland<mark.rutland@arm.com>
> > CC: Ian Campbell<ijc+devicetree@hellion.org.uk>
> > CC: Kumar Gala<galak@codeaurora.org>
> > CC: Randy Dunlap<rdunlap@infradead.org>
> > CC: Grant Likely<grant.likely@linaro.org>
> > ---
> >   drivers/pci/host/pcie-designware.c |  105 +++++++++++++++++++++++++-----------
> >   drivers/pci/host/pcie-designware.h |    3 +-
> >   2 files changed, 75 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > index 905941c..c11e4de 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -415,19 +415,24 @@ static const struct irq_domain_ops msi_domain_ops = {
> >   	.map = dw_pcie_msi_map,
> >   };
> >
> > -int __init dw_pcie_host_init(struct pcie_port *pp)
> > +static int __init dw_pcie_common_host_init(struct pcie_port *pp,
> > +					   struct hw_pci *hw)
> >   {
> >   	struct device_node *np = pp->dev->of_node;
> >   	struct of_pci_range range;
> >   	struct of_pci_range_parser parser;
> > +	struct hw_pci *pci_hw = hw;
> >   	u32 val;
> > -	int i;
> >
> >   	if (of_pci_range_parser_init(&parser, np)) {
> >   		dev_err(pp->dev, "missing ranges property\n");
> >   		return -EINVAL;
> >   	}
> >
> > +	/* Default to dw_pci if no hw ops provided */
> > +	if (!pci_hw)
> > +		pci_hw =&dw_pci;
> > +
> >   	/* Get the I/O and memory ranges from DT */
> >   	for_each_of_pci_range(&parser,&range) {
> >   		unsigned long restype = range.flags&  IORESOURCE_TYPE_BITS;
> > @@ -467,21 +472,24 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >   		}
> >   	}
> >
> > -	pp->cfg0_base = pp->cfg.start;
> > -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> >   	pp->mem_base = pp->mem.start;
> > -
> > -	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> > -					pp->config.cfg0_size);
> > -	if (!pp->va_cfg0_base) {
> > -		dev_err(pp->dev, "error with ioremap in function\n");
> > -		return -ENOMEM;
> > -	}
> > -	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> > -					pp->config.cfg1_size);
> > -	if (!pp->va_cfg1_base) {
> > -		dev_err(pp->dev, "error with ioremap\n");
> > -		return -ENOMEM;
> > +	if (!pp->version&  DW_HW_V3_65) {
> > +		/* Default is with ATU port. */
> > +		pp->cfg0_base = pp->cfg.start;
> > +		pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> > +
> > +		pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> > +						pp->config.cfg0_size);
> > +		if (!pp->va_cfg0_base) {
> > +			dev_err(pp->dev, "error with ioremap in function\n");
> > +			return -ENOMEM;
> > +		}
> > +		pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> > +						pp->config.cfg1_size);
> > +		if (!pp->va_cfg1_base) {
> > +			dev_err(pp->dev, "error with ioremap\n");
> > +			return -ENOMEM;
> > +		}
> >   	}
> >
> >   	if (of_property_read_u32(np, "num-lanes",&pp->lanes)) {
> > @@ -489,19 +497,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >   		return -EINVAL;
> >   	}
> >
> > -	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > -		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> > -					MAX_MSI_IRQS,&msi_domain_ops,
> > -					&dw_pcie_msi_chip);
> > -		if (!pp->irq_domain) {
> > -			dev_err(pp->dev, "irq domain init failed\n");
> > -			return -ENXIO;
> > -		}
> > -
> > -		for (i = 0; i<  MAX_MSI_IRQS; i++)
> > -			irq_create_mapping(pp->irq_domain, i);
> > -	}
> > -
> >   	if (pp->ops->host_init)
> >   		pp->ops->host_init(pp);
> >
> > @@ -514,10 +509,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >   	val |= PORT_LOGIC_SPEED_CHANGE;
> >   	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
> >
> > -	dw_pci.nr_controllers = 1;
> > -	dw_pci.private_data = (void **)&pp;
> > +	pci_hw->nr_controllers = 1;
> > +	pci_hw->private_data = (void **)&pp;
> >
> > -	pci_common_init_dev(pp->dev,&dw_pci);
> > +	pci_common_init_dev(pp->dev, pci_hw);
> >   	pci_assign_unassigned_resources();
> >   #ifdef CONFIG_PCI_DOMAINS
> >   	dw_pci.domain++;
> > @@ -526,6 +521,52 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >   	return 0;
> >   }
> >
> > +/*
> > + * dw_pcie_msi_host_init() - Function to initialize msi host controller
> > + * @pp: ptr to pcie port
> > + * @msi_irqc_np: device node ptr to msi irq controller
> > + * @irq_msi_ops: ptr to MSI irq_domain_ops struct
> > + *
> > + * Function register irq domain for msi irq controller and create mappings
> > + * for MSI irqs.
> > + */
> > +static int dw_pcie_msi_host_init(struct pcie_port *pp,
> > +				 struct device_node *msi_irqc_np,
> > +				 const struct irq_domain_ops *msi_irq_ops)
> > +{
> > +	const struct irq_domain_ops *msi_irq_domain_ops = msi_irq_ops;
> > +	int i;
> > +
> > +	/* Default to  msi_domain_ops if no msi irq domain ops provided */
> > +	if (!msi_irq_domain_ops)
> > +		msi_irq_domain_ops =&msi_domain_ops;
> > +
> > +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +		pp->irq_domain = irq_domain_add_linear(msi_irqc_np,
> > +					MAX_MSI_IRQS, msi_irq_domain_ops,
> > +					&dw_pcie_msi_chip);
> > +		if (!pp->irq_domain) {
> > +			dev_err(pp->dev, "irq domain init failed\n");
> > +			return -ENXIO;
> > +		}
> > +
> > +		for (i = 0; i<  MAX_MSI_IRQS; i++)
> > +			irq_create_mapping(pp->irq_domain, i);
> > +	}
> > +	return 0;
> > +}
> > +
> > +int __init dw_pcie_host_init(struct pcie_port *pp)
> > +{
> > +	int ret;
> > +
> > +	ret = dw_pcie_msi_host_init(pp, pp->dev->of_node, NULL);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return dw_pcie_common_host_init(pp, NULL);
> > +}
> > +
> >   static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> >   {
> >   	/* Program viewport 0 : OUTBOUND : CFG0 */
> > diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> > index 387f69e..db0260f 100644
> > --- a/drivers/pci/host/pcie-designware.h
> > +++ b/drivers/pci/host/pcie-designware.h
> > @@ -51,6 +51,8 @@ struct pcie_port {
> >   	int			msi_irq;
> >   	struct irq_domain	*irq_domain;
> >   	unsigned long		msi_data;
> > +#define DW_HW_V3_65		BIT(0)
> > +	u32			version;
> >   	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
> >   };
> >
> > @@ -79,5 +81,4 @@ void dw_pcie_msi_init(struct pcie_port *pp);
> >   int dw_pcie_link_up(struct pcie_port *pp);
> >   void dw_pcie_setup_rc(struct pcie_port *pp);
> >   int dw_pcie_host_init(struct pcie_port *pp);
> > -
> >   #endif /* _PCIE_DESIGNWARE_H */


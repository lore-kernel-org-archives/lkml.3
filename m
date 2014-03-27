Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaC0Lyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:54:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53770 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbaC0Lyu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:54:50 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        Pratyush ANAND <pratyush.anand@st.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>, "rnayak@ti.com" <rnayak@ti.com>,
        "paul@pwsan.com" <paul@pwsan.com>, "'Marek Vasut'" <marex@denx.de>,
        "'Richard Zhu'" <r65037@freescale.com>
Date: Thu, 27 Mar 2014 19:53:26 +0800
Subject: RE: [RFC PATCH 03/12] pci: host: pcie-designware: Use *base-mask*
 for configuring the iATU
Thread-Topic: [RFC PATCH 03/12] pci: host: pcie-designware: Use *base-mask*
 for configuring the iATU
Thread-Index: Ac9I+4kHfk49qKvMS7SN4ZGGUMaHhAAta6iwAABi5vA=
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189FEB12DF6@EAPEX1MAIL1.st.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
 <1395842272-15267-4-git-send-email-kishon@ti.com>
 <000001cf49b1$fcd8a810$f689f830$%han@samsung.com>
In-Reply-To: <000001cf49b1$fcd8a810$f689f830$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-27_03:2014-03-27,2014-03-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kishon,

> -----Original Message-----
> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Thursday, March 27, 2014 5:15 PM
> To: 'Kishon Vijay Abraham I'; Mohit KUMAR DCG; Pratyush ANAND
> Cc: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> omap@vger.kernel.org; linux-pci@vger.kernel.org; bhelgaas@google.com;
> robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> ijc+devicetree@hellion.org.uk; galak@codeaurora.org; rob@landley.net;
> linux@arm.linux.org.uk; tony@atomide.com; rnayak@ti.com;
> paul@pwsan.com; 'Marek Vasut'; 'Richard Zhu'
> Subject: Re: [RFC PATCH 03/12] pci: host: pcie-designware: Use *base-mask*
> for configuring the iATU
> 
> On Wednesday, March 26, 2014 10:58 PM, Kishon Vijay Abraham I wrote:
> >
> > In DRA7, the cpu sees 32bit address, but the pcie controller can see
> > only 28bit address. So whenever the cpu issues a read/write request,
> > the 4 most significant bits are used by L3 to determine the target controller.
> > For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe
> > controller but the PCIe controller will see only (0x000_0000 -
> > 0xFFF_FFF). So for programming the outbound translation window the
> *base* should be programmed as 0x000_0000.
> > Whenever we try to write to say 0x2000_0000, it will be translated to
> > whatever we have programmed in the translation window with base as
> 0x000_0000.
> >
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> (+cc Pratyush Anand, Marek Vasut, Richard Zhu)
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> Mohit Kumar, Pratyush Anand,
> If you have other opinions, please let us know. :-) Thank you.
> 

- Yes, looks more clean now.
Acked-by: Mohit Kumar <mohit.kumar@st.com>

Regards,
Mohit

> Best regards,
> Jingoo Han
> 
> > ---
> >  .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
> >  drivers/pci/host/pcie-designware.c                 |   39 ++++++++++++++------
> >  drivers/pci/host/pcie-designware.h                 |    1 +
> >  3 files changed, 29 insertions(+), 12 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > index d6fae13..c574dd3 100644
> > --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> > @@ -27,6 +27,7 @@ Optional properties for fsl,imx6q-pcie
> >  - power-on-gpio: gpio pin number of power-enable signal
> >  - wake-up-gpio: gpio pin number of incoming wakeup signal
> >  - disable-gpio: gpio pin number of outgoing rfkill/endpoint disable
> > signal
> > +- base-mask: address mask for the PCIe controller target port
> >
> >  Example:
> >
> > diff --git a/drivers/pci/host/pcie-designware.c
> > b/drivers/pci/host/pcie-designware.c
> > index 17ce88f..98b661c 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -464,6 +464,9 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> >  		return -EINVAL;
> >  	}
> >
> > +	if (of_property_read_u64(np, "base-mask", &pp->base_mask))
> > +		pp->base_mask = ~(0x0ULL);
> > +
> >  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> >  		pp->irq_domain = irq_domain_add_linear(pp->dev-
> >of_node,
> >  					MAX_MSI_IRQS, &msi_domain_ops,
> > @@ -503,12 +506,15 @@ int __init dw_pcie_host_init(struct pcie_port
> > *pp)
> >
> >  static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32
> > busdev)  {
> > +	u64 cfg0_base;
> > +
> > +	cfg0_base = pp->cfg0_base & pp->base_mask;
> >  	/* Program viewport 0 : OUTBOUND : CFG0 */
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND |
> PCIE_ATU_REGION_INDEX0,
> >  			  PCIE_ATU_VIEWPORT);
> > -	dw_pcie_writel_rc(pp, pp->cfg0_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->cfg0_base >> 32),
> PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->cfg0_base + pp->config.cfg0_size - 1,
> > +	dw_pcie_writel_rc(pp, cfg0_base, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (cfg0_base >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, cfg0_base + pp->config.cfg0_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET); @@ -518,14
> +524,17
> > @@ static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32
> > busdev)
> >
> >  static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32
> > busdev)  {
> > +	u64 cfg1_base;
> > +
> > +	cfg1_base = pp->cfg1_base & pp->base_mask;
> >  	/* Program viewport 1 : OUTBOUND : CFG1 */
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND |
> PCIE_ATU_REGION_INDEX1,
> >  			  PCIE_ATU_VIEWPORT);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> > -	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32),
> PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
> > +	dw_pcie_writel_rc(pp, cfg1_base, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, cfg1_base + pp->config.cfg1_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET); @@ -533,14
> +542,17
> > @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32
> > busdev)
> >
> >  static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port
> *pp)
> > {
> > +	u64 mem_base;
> > +
> > +	mem_base = pp->mem_base & pp->base_mask;
> >  	/* Program viewport 0 : OUTBOUND : MEM */
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND |
> PCIE_ATU_REGION_INDEX0,
> >  			  PCIE_ATU_VIEWPORT);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> > -	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->mem_base >> 32),
> PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
> > +	dw_pcie_writel_rc(pp, mem_base, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (mem_base >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, mem_base + pp->config.mem_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr,
> PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
> > @@ -549,14 +561,17 @@ static void
> > dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
> >
> >  static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
> > {
> > +	u64 io_base;
> > +
> > +	io_base = pp->io_base & pp->base_mask;
> >  	/* Program viewport 1 : OUTBOUND : IO */
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND |
> PCIE_ATU_REGION_INDEX1,
> >  			  PCIE_ATU_VIEWPORT);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
> >  	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
> > -	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
> > -	dw_pcie_writel_rc(pp, (pp->io_base >> 32),
> PCIE_ATU_UPPER_BASE);
> > -	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
> > +	dw_pcie_writel_rc(pp, io_base, PCIE_ATU_LOWER_BASE);
> > +	dw_pcie_writel_rc(pp, (io_base >> 32), PCIE_ATU_UPPER_BASE);
> > +	dw_pcie_writel_rc(pp, io_base + pp->config.io_size - 1,
> >  			  PCIE_ATU_LIMIT);
> >  	dw_pcie_writel_rc(pp, pp->config.io_bus_addr,
> PCIE_ATU_LOWER_TARGET);
> >  	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
> > diff --git a/drivers/pci/host/pcie-designware.h
> > b/drivers/pci/host/pcie-designware.h
> > index 3063b35..3fa12a6 100644
> > --- a/drivers/pci/host/pcie-designware.h
> > +++ b/drivers/pci/host/pcie-designware.h
> > @@ -35,6 +35,7 @@ struct pcie_port {
> >  	struct device		*dev;
> >  	u8			root_bus_nr;
> >  	void __iomem		*dbi_base;
> > +	u64			base_mask;
> >  	u64			cfg0_base;
> >  	void __iomem		*va_cfg0_base;
> >  	u64			cfg1_base;
> > --
> > 1.7.9.5


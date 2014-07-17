Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaGQETr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:19:47 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:60722 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbaGQETp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:19:45 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>,
        "Jingoo Han (jg1.han@samsung.com)" <jg1.han@samsung.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pratyush ANAND <pratyush.anand@st.com>
Date: Thu, 17 Jul 2014 12:18:11 +0800
Subject: RE: [PATCH v5 3/5] PCI: designware: enhance dw_pcie_host_init() to
 support v3.65 DW hardware
Thread-Topic: [PATCH v5 3/5] PCI: designware: enhance dw_pcie_host_init() to
 support v3.65 DW hardware
Thread-Index: Ac+hcFHGnm6M98GsThCirMzgWRyIKgABNv5g
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661A47A2A83BB@EAPEX1MAIL1.st.com>
References: <1405528686-16539-1-git-send-email-m-karicheri2@ti.com>
 <1405528686-16539-4-git-send-email-m-karicheri2@ti.com>
 <20140717033638.GI12278@pratyush-vbox>
In-Reply-To: <20140717033638.GI12278@pratyush-vbox>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-17_01:2014-07-16,2014-07-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Pratyush ANAND
> Sent: Thursday, July 17, 2014 9:07 AM
> To: Murali Karicheri
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Santosh Shilimkar; Russell King; Grant Likely; Rob
> Herring; Mohit KUMAR DCG; Jingoo Han; Bjorn Helgaas; Richard Zhu; Kishon
> Vijay Abraham I; Marek Vasut; Arnd Bergmann; Pawel Moll; Mark Rutland;
> Ian Campbell; Kumar Gala; Randy Dunlap
> Subject: Re: [PATCH v5 3/5] PCI: designware: enhance dw_pcie_host_init()
> to support v3.65 DW hardware
> 
> On Thu, Jul 17, 2014 at 12:38:04AM +0800, Murali Karicheri wrote:
> > keystone PCI controller is based on v3.65 designware hardware. This
> > version differs from newer versions of the hardware in few functional
> > areas discussed below that makes it necessary to change
> > dw_pcie_host_init() to support v3.65 based PCI controller.
> >
> >  1. No support for ATU port. So any ATU specific resource handling code
> >     is to be bypassed for v3.65 h/w.
> >  2. MSI controller uses Application space to implement MSI and 32 MSI
> >     interrupts are multiplexed over 8 IRQs to the host. Hence the code
> >     to process MSI IRQ needs to be different. This patch allows platform
> >     driver to provide its own irq_domain_ops ptr to irq_domain_add_linear()
> >     through an API callback from the designware core driver.
> >  3. MSI interrupt generation requires EP to write to the RC's application
> >     register. So enhance the driver to allow setup of inbound access to
> >     MSI irq register as a post scan bus API callback.
> >
> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> Looks almost ok to me.
> 
> Reviewed-by: Pratyush Anand <pratyush.anand@st.com>
> 

- Now looks fine to me.

Acked-by: Mohit KUMAR <mohit.kumar@st.com>

Jingoo,
After Murali's patches,  dw code can be used by  older Synopsys controller based driver too.
Pls have a look at the series if you have any further comment.

Thanks
Mohit

> >  int __init dw_pcie_host_init(struct pcie_port *pp)  {
> >  	struct device_node *np = pp->dev->of_node;
> > -	struct of_pci_range range;
> >  	struct of_pci_range_parser parser;
> > +	struct of_pci_range range;
> 
> You may avoid moving the above line.
> 
> ~Pratyush

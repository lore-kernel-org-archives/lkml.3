Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaGQDiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:38:09 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44345 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbaGQDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:38:04 -0400
Date: Thu, 17 Jul 2014 09:06:38 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 3/5] PCI: designware: enhance dw_pcie_host_init() to
 support v3.65 DW hardware
Message-ID: <20140717033638.GI12278@pratyush-vbox>
References: <1405528686-16539-1-git-send-email-m-karicheri2@ti.com>
 <1405528686-16539-4-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405528686-16539-4-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-17_01:2014-07-16,2014-07-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:38:04AM +0800, Murali Karicheri wrote:
> keystone PCI controller is based on v3.65 designware hardware. This
> version differs from newer versions of the hardware in few functional
> areas discussed below that makes it necessary to change dw_pcie_host_init()
> to support v3.65 based PCI controller.
> 
>  1. No support for ATU port. So any ATU specific resource handling code
>     is to be bypassed for v3.65 h/w.
>  2. MSI controller uses Application space to implement MSI and 32 MSI
>     interrupts are multiplexed over 8 IRQs to the host. Hence the code
>     to process MSI IRQ needs to be different. This patch allows platform
>     driver to provide its own irq_domain_ops ptr to irq_domain_add_linear()
>     through an API callback from the designware core driver.
>  3. MSI interrupt generation requires EP to write to the RC's application
>     register. So enhance the driver to allow setup of inbound access to
>     MSI irq register as a post scan bus API callback.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Looks almost ok to me.

Reviewed-by: Pratyush Anand <pratyush.anand@st.com>

>  int __init dw_pcie_host_init(struct pcie_port *pp)
>  {
>  	struct device_node *np = pp->dev->of_node;
> -	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> +	struct of_pci_range range;

You may avoid moving the above line.

~Pratyush

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbaGQPGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:06:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55510 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357AbaGQPGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:06:20 -0400
Message-ID: <53C7E613.3080102@ti.com>
Date: Thu, 17 Jul 2014 11:04:51 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
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
References: <1405528686-16539-1-git-send-email-m-karicheri2@ti.com> <1405528686-16539-4-git-send-email-m-karicheri2@ti.com> <20140717033638.GI12278@pratyush-vbox>
In-Reply-To: <20140717033638.GI12278@pratyush-vbox>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 11:36 PM, Pratyush Anand wrote:
> On Thu, Jul 17, 2014 at 12:38:04AM +0800, Murali Karicheri wrote:
>> keystone PCI controller is based on v3.65 designware hardware. This
>> version differs from newer versions of the hardware in few functional
>> areas discussed below that makes it necessary to change dw_pcie_host_init()
>> to support v3.65 based PCI controller.
>>
>>   1. No support for ATU port. So any ATU specific resource handling code
>>      is to be bypassed for v3.65 h/w.
>>   2. MSI controller uses Application space to implement MSI and 32 MSI
>>      interrupts are multiplexed over 8 IRQs to the host. Hence the code
>>      to process MSI IRQ needs to be different. This patch allows platform
>>      driver to provide its own irq_domain_ops ptr to irq_domain_add_linear()
>>      through an API callback from the designware core driver.
>>   3. MSI interrupt generation requires EP to write to the RC's application
>>      register. So enhance the driver to allow setup of inbound access to
>>      MSI irq register as a post scan bus API callback.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> Looks almost ok to me.
>
> Reviewed-by: Pratyush Anand<pratyush.anand@st.com>
>
>>   int __init dw_pcie_host_init(struct pcie_port *pp)
>>   {
>>   	struct device_node *np = pp->dev->of_node;
>> -	struct of_pci_range range;
>>   	struct of_pci_range_parser parser;
>> +	struct of_pci_range range;
> You may avoid moving the above line.
Thought the variables are to be sorted. I can fix this when I resend it 
today with your reviewed by and Mohit's Ack.

Regards,

Murali
> ~Pratyush


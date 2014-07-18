Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946075AbaGRURS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:17:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaGRURR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:17:17 -0400
Message-ID: <53C98079.4080707@ti.com>
Date: Fri, 18 Jul 2014 16:15:53 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com> <5467203.eMVRoNeSx1@wuerfel>
In-Reply-To: <5467203.eMVRoNeSx1@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 03:50 PM, Arnd Bergmann wrote:
> On Friday 18 July 2014 14:31:39 Rob Herring wrote:
>>> +
>>> + Example:
>>> +       pcie_msi_intc: msi-interrupt-controller {
>>> +                       interrupt-controller;
>>> +                       #interrupt-cells =<1>;
>>> +                       interrupt-parent =<&gic>;
>>> +                       interrupts =<GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
>>> +       };
>>> +
>>> +pcie_intc: Interrupt controller device node for Legacy irq chip
>>> +       interrupt-cells: should be set to 1
>>> +       interrupt-parent: Parent interrupt controller phandle
>>> +       interrupts: GIC interrupt lines connected to PCI Legacy interrupt lines
>>> +
>>> + Example:
>>> +       pcie_intc: legacy-interrupt-controller {
>>> +               interrupt-controller;
>>> +               #interrupt-cells =<1>;
>>> +               interrupt-parent =<&gic>;
>>> +               interrupts =<GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
>>> +<GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
>>> +       };
>> This seems wrong. Legacy interrupts should be described with
>> interrupt-map and then PCI child devices have a standard interrupt
>> specifier.
>>
>> I'm not sure about MSIs, but I would think they would have a standard
>> format too.
>>
> IIRC, it's actually the correct way to do this here: the problem is that
> the PCI IRQs are not directly connected to the GIC, but instead there is
> a nested irqchip that has each PCI IRQ routed to it and that requires
> an extra EOI for each interrupt.
>
> The interrupt-map in the PCI host points to this special irqchip rather
> than to the GIC.
Arnd,

Thanks. I agree with Arnd and believe there is no issue here

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


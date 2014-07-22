Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaGVTCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:02:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbaGVTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:37 -0400
Message-ID: <53CEB4C7.1020601@ti.com>
Date: Tue, 22 Jul 2014 15:00:23 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
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
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com> <5467203.eMVRoNeSx1@wuerfel> <CAL_JsqLrh_M0gTRezST9jX1X_5Eo98taNcHok6QX6vDMxeqkcw@mail.gmail.com>
In-Reply-To: <CAL_JsqLrh_M0gTRezST9jX1X_5Eo98taNcHok6QX6vDMxeqkcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 11:37 AM, Rob Herring wrote:
> On Fri, Jul 18, 2014 at 2:50 PM, Arnd Bergmann<arnd@arndb.de>  wrote:
>> On Friday 18 July 2014 14:31:39 Rob Herring wrote:
>>>> +
>>>> + Example:
>>>> +       pcie_msi_intc: msi-interrupt-controller {
>>>> +                       interrupt-controller;
>>>> +                       #interrupt-cells =<1>;
>>>> +                       interrupt-parent =<&gic>;
>>>> +                       interrupts =<GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
>>>> +       };
>>>> +
>>>> +pcie_intc: Interrupt controller device node for Legacy irq chip
>>>> +       interrupt-cells: should be set to 1
>>>> +       interrupt-parent: Parent interrupt controller phandle
>>>> +       interrupts: GIC interrupt lines connected to PCI Legacy interrupt lines
>>>> +
>>>> + Example:
>>>> +       pcie_intc: legacy-interrupt-controller {
>>>> +               interrupt-controller;
>>>> +               #interrupt-cells =<1>;
>>>> +               interrupt-parent =<&gic>;
>>>> +               interrupts =<GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
>>>> +<GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
>>>> +       };
>>> This seems wrong. Legacy interrupts should be described with
>>> interrupt-map and then PCI child devices have a standard interrupt
>>> specifier.
>>>
>>> I'm not sure about MSIs, but I would think they would have a standard
>>> format too.
>>>
>> IIRC, it's actually the correct way to do this here: the problem is that
>> the PCI IRQs are not directly connected to the GIC, but instead there is
>> a nested irqchip that has each PCI IRQ routed to it and that requires
>> an extra EOI for each interrupt.
>>
>> The interrupt-map in the PCI host points to this special irqchip rather
>> than to the GIC.
> Okay, if there is still an interrupt-map property, then I agree. This
> wasn't clear in the example.
Rob,

There is and is described in designware DT documentation. This documentation
refers to that and also describe DT bindings specific to Keystone. Could you
Ack this based on this?

Murali
>
> Rob


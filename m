Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaEGJXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:23:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51705 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbaEGJXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:23:35 -0400
Message-ID: <5369FB67.6040905@ti.com>
Date: Wed, 7 May 2014 14:52:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, <balajitk@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <rogerq@ti.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-6-git-send-email-kishon@ti.com> <20140506163507.GA15542@obsidianresearch.com>
In-Reply-To: <20140506163507.GA15542@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 06 May 2014 10:05 PM, Jason Gunthorpe wrote:
> On Tue, May 06, 2014 at 07:03:51PM +0530, Kishon Vijay Abraham I wrote:
>> +Example:
>> +pcie@51000000 {
>> +	compatible = "ti,dra7xx-pcie";
>> +	reg = <0x51002000 0x14c>, <0x51000000 0x2000>;
>> +	reg-names = "ti_conf", "rc_dbics";
>> +	interrupts = <0 232 0x4>, <0 233 0x4>;
>> +	#address-cells = <3>;
>> +	#size-cells = <2>;
>> +	device_type = "pci";
>> +	ti,device_type = <3>;
>> +	ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* Configuration Space */
> 
> Configuration space should not show up in the ranges, please don't
> copy that mistake from other drivers, put it in reg.

But then it needs pcie-designware.c to be modified and it will be breaking
other platforms no?
> 
>> +	interrupt-map-mask = <0 0 0 0>;
>> +	interrupt-map = <0x0 0 &gic 134>;
> 
> The HW cannot decode INTA/B/C/D?
> 
>> +#define	PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI		0x0034
>> +#define	PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI		0x0038
>> +#define	INTA						BIT(0)
>> +#define	INTB						BIT(1)
>> +#define	INTC						BIT(2)
>> +#define	INTD						BIT(3)
>> +#define	MSI						BIT(4)
>> +#define	LEG_EP_INTERRUPTS (INTA | INTB | INTC | INTD)
> 
> Oh, it can, it would be wise to export this from the driver. Look at
> the latest patches from Srikanth Thokala for the Xilinx PCI driver to
> see how this should look

ok.. will have a look at it.

Thanks
Kishon

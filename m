Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaC0F1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:27:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50677 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaC0F1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:27:10 -0400
Message-ID: <5333B66A.8020804@ti.com>
Date: Thu, 27 Mar 2014 10:56:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <rnayak@ti.com>, <paul@pwsan.com>
Subject: Re: [RFC PATCH 02/12] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1395842272-15267-1-git-send-email-kishon@ti.com> <1395842272-15267-3-git-send-email-kishon@ti.com> <000c01cf496e$bf2c85b0$3d859110$%han@samsung.com>
In-Reply-To: <000c01cf496e$bf2c85b0$3d859110$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 27 March 2014 09:13 AM, Jingoo Han wrote:
> On Wednesday, March 26, 2014 10:58 PM, Kishon Vijay Abraham I wrote:
>>
>> Added support for pcie controller in dra7xx. This driver re-uses
>> the designware core code that is already present in kernel.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Hi Kishon,
> Long time no see! I added trivial comments.

yeah, these were in my TODO for a long time. Sorry for it though.
> 
>> ---
>>  Documentation/devicetree/bindings/pci/ti-pci.txt |   35 ++
>>  drivers/pci/host/Kconfig                         |   10 +
>>  drivers/pci/host/Makefile                        |    1 +
>>  drivers/pci/host/pcie-dra7xx.c                   |  411 ++++++++++++++++++++++
> 
> How about using 'pci-' prefix?
> As it was discussed earlier, 'pci-' prefix is more proper.
> 
>>  4 files changed, 457 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>>  create mode 100644 drivers/pci/host/pcie-dra7xx.c
> 
> [.....]
> 
>> --- /dev/null
>> +++ b/drivers/pci/host/pcie-dra7xx.c
> 
> [.....]
> 
>> +#define	PCIECTRL_TI_CONF_IRQSTATUS_MAIN		0x0024
>> +#define	PCIECTRL_TI_CONF_IRQENABLE_SET_MAIN	0x0028
> 
> I don't think that it's good to add vendor names such as TI
> to SFR names.
> 
> How about adding 'DRA7XX' or just removing 'TI'?
> 
> 1. PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN

ok.
> 
> 2. PCIECTRL_CONF_IRQSTATUS_MAIN
> 
> [.....]
> 
>> +enum dra7xx_pcie_device_type {
>> +	DRA7XX_PCIE_UNKNOWN_TYPE,
>> +	DRA7XX_PCIE_EP_TYPE,
>> +	DRA7XX_PCIE_LEG_EP_TYPE,
>> +	DRA7XX_PCIE_RC_TYPE,
>> +};
> 
> This driver can support only RC mode, so, these enum can be removed.
> 
> [.....]
> 
>> +	of_property_read_u32(node, "ti,device-type", &device_type);
>> +	switch (device_type) {
>> +	case DRA7XX_PCIE_RC_TYPE:
>> +		dra7xx_pcie_writel(dra7xx->base,
>> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_RC);
>> +		break;
>> +	case DRA7XX_PCIE_EP_TYPE:
>> +		dra7xx_pcie_writel(dra7xx->base,
>> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_EP);
>> +		break;
>> +	case DRA7XX_PCIE_LEG_EP_TYPE:
>> +		dra7xx_pcie_writel(dra7xx->base,
>> +			PCIECTRL_TI_CONF_DEVICE_TYPE, DEVICE_TYPE_LEG_EP);
>> +		break;
>> +	default:
>> +		dev_dbg(dev, "UNKNOWN device type %d\n", device_type);
>> +	}
> 
> Thus, this switch can be removed.

sure.

Thanks
Kishon

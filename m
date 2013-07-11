Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3GKIfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:35:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab3GKIff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:35:35 -0400
Message-ID: <51DE6E46.3030204@ti.com>
Date: Thu, 11 Jul 2013 14:05:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        <linux-kernel@vger.kernel.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <001201ce7dfa$716b3370$54419a50$@samsung.com> <51DE5359.90905@ti.com> <000001ce7e05$13ab4210$3b01c630$@samsung.com>
In-Reply-To: <000001ce7e05$13ab4210$3b01c630$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 July 2013 12:35 PM, Jingoo Han wrote:
> On Thursday, July 11, 2013 3:40 PM, Kishon Vijay Abraham I wrote:
>> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
>>>
>>>  drivers/pci/host/Makefile          |    1 +
>>>  drivers/pci/host/pcie-designware.c |  963 +++++++++---------------------------
>>>  drivers/pci/host/pcie-designware.h |   71 +++
>>>  drivers/pci/host/pcie-exynos.c     |  523 ++++++++++++++++++++
>>>  4 files changed, 822 insertions(+), 736 deletions(-)
>>>  create mode 100644 drivers/pci/host/pcie-designware.h
>>>  create mode 100644 drivers/pci/host/pcie-exynos.c
>>>
>>> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
>>> index 086d850..7e59864 100644
>>> --- a/drivers/pci/host/Makefile
>>> +++ b/drivers/pci/host/Makefile
>>> @@ -1,2 +1,3 @@
>>>  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
>>>  obj-$(CONFIG_PCIE_DW) += pcie-designware.o
>>> +obj-$(CONFIG_PCI_EXYNOS) += pcie-exynos.o
>>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> [...]
>>
>> How about making this a separate driver in itself that does all the
>> configurations for designware core? By this I mean we can have a separate dt
>> node (child node of soc specific wrapper), that will have all the configuration
>> space/IO space and memory space. pci_common_init/dw_pcie_host_init should be
>> done in this driver.
>> We just need to think about a way of passing the ops (since that looks like
>> very much needed because of the sideband bits you have to enable before
>> reading/writing).
>>
> 
> CC'ed Seungwon Jeon(DW-MMC Maintainer), Yulgon Kim (DW-USB Developer)
> 
> 
> Um, maybe you mean dwc3 usb driver (./drivers/usb/dwc3/)'?
> 
> But, I referenced dw mmc driver (./drivers/mmc/host/dw_mmc*.c).
> 
> Now, Exynos PCIe driver, Spear PCIe driver[1], and i.MX PCIe driver[2]
> are submitted to PCIe mailing-list, these are using designware PCIe core.
> 
> There are many differences between Exynos PCIe and Spear PCIe.
> Also, for Exynos PCIe, platform specific part will be changed more.
> 
> Thus, the dw mmc driver model looked more suitable.

Alright. I'll go ahead with a similar implementation then.

Thanks
Kishon

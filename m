Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbbASDNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:13:14 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39692 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbASDNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:13:11 -0500
Message-ID: <54BC7632.1080003@huawei.com>
Date: Mon, 19 Jan 2015 11:12:50 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Marc Zyngier" <marc.zyngier@arm.com>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-alpha@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 10/28] PCI: Save sysdata in pci_host_bridge drvdata
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-11-git-send-email-wangyijing@huawei.com> <18973877.BYCS6vtzoq@wuerfel>
In-Reply-To: <18973877.BYCS6vtzoq@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/16 17:18, Arnd Bergmann wrote:
> On Friday 16 January 2015 09:44:08 Yijing Wang wrote:
>> @@ -2066,11 +2064,11 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
>>  {
>>         struct pci_host_bridge *host;
>>  
>> -       host = pci_create_host_bridge(parent, db, resources);
>> +       host = pci_create_host_bridge(parent, db, resources, sysdata);
>>         if (!host)
>>                 return NULL;
>>  
>> -       return __pci_scan_root_bus(host, ops, sysdata);
>> +       return __pci_scan_root_bus(host, ops);
>>  }
>>  EXPORT_SYMBOL(pci_scan_root_bus);
>>
> 
> How about keeping the sysdata out of the pci_create_host_bridge interface, and
> refactoring it so that the call sequence becomes
> 
> 	host = pci_create_host_bridge(parent, db, resources);
> 	host->sysdata = sysdata;
> 	__pci_scan_root_bus(host, ops);
> 
> This way, we can make sysdata completely option. I assume that more of the
> fields we have in sysdata today can get moved into pci_host_bridge
> over time, so a host bridge driver can just assign those members individually
> between pci_create_host_bridge and __pci_scan_root_bus.

I put the sysdata in pci_host_bridge, because some platforms x86/ia64
need to call pcibios_root_bridge_prepare() before pci_host_bridge registration
in pci_create_host_bridge(), and pcibios_root_bridge_prepare() need the companion
acpi device pointer which is stored in sysdata.

I like you idea, but I haven't find a better way yet.

Thanks!
Yijing.

> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing


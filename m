Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbbASDSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:18:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43634 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASDSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:18:04 -0500
Message-ID: <54BC775B.5020400@huawei.com>
Date: Mon, 19 Jan 2015 11:17:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        "Russell King" <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-alpha@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 23/28] PCI/designware: Use pci_scan_root_bus() for simplicity
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-24-git-send-email-wangyijing@huawei.com> <54BA9052.9080904@cogentembedded.com>
In-Reply-To: <54BA9052.9080904@cogentembedded.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/18 0:39, Sergei Shtylyov wrote:
> Hello.
> 
> On 1/16/2015 4:44 AM, Yijing Wang wrote:
> 
>> Use pci_scan_root_bus() instead of pci_create_root_bus() +
>> pci_scan_child_bus() for simplicity.
> 
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>   drivers/pci/host/pcie-designware.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
> 
>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
>> index eef3111..d37fe27 100644
>> --- a/drivers/pci/host/pcie-designware.c
>> +++ b/drivers/pci/host/pcie-designware.c
>> @@ -725,13 +725,11 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>>       struct pcie_port *pp = sys_to_pcie(sys);
>>
>>       pp->root_bus_nr = sys->busnr;
>> -    bus = pci_create_root_bus(pp->dev, sys->busnr,
>> +    bus = pci_scan_root_bus(pp->dev, sys->busnr,
>>                     &dw_pcie_ops, sys, &sys->resources);
> 
>    Please realign this line, so that it still starts under 'pp'.

ok.

> 
> WBR, Sergei
> 
> 
> .
> 


-- 
Thanks!
Yijing


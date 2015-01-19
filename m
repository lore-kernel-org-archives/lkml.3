Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbASCR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:17:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3118 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbbASCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:17:57 -0500
Message-ID: <54BC6894.6060500@huawei.com>
Date: Mon, 19 Jan 2015 10:14:44 +0800
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
        Jiang Liu <jiang.liu@linux.intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 08/28] PCI: Introduce pci_host_assign_domain_nr() to assign
 domain
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-9-git-send-email-wangyijing@huawei.com> <13182982.DnZJMY2KHL@wuerfel> <3026954.09KG7UaUTi@wuerfel>
In-Reply-To: <3026954.09KG7UaUTi@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm confused: the same code is already part of the PCI tree, but with
>> Lorenzo Pieralisi listed as the patch author. The code is good,
>> and I acked it in the past, but one of you is (probably by accident)
>> misattributing the patch.
>>
>> Assuming that the patch that is already merged in next is the right
>> one, I think you should rebase your series on top of
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git#next
>>
>> to avoid conflicts like this one.
>>
> 
> I think I just got confused because the code duplicates most of
> pci_bus_assign_domain_nr(). Maybe this can be done in a better way
> by splitting the existing function into 
> 
> static int pci_assign_domain_nr(struct device *)
> {
> 	... /* most of pci_bus_assign_domain_nr */
> 
> 	return domain;
> }
> 
> void pci_host_assign_domain_nr(struct pci_host_bridge *host)
> {
> 	host->domain = pci_assign_domain_nr(host->dev.parent);
> }
> 
> void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
> {
> 	bus->domain_nr = pci_assign_domain_nr(parent);
> }
> 

Hi Arnd,
   I kept the almost duplicated pci_host_assign_domain_nr() and
pci_bus_assign_domain_nr() here for building happy, because now
platform specific pci_domain_nr() still exists which may get domain
number from pci_bus. pci_bus_assign_domain_nr() will be removed in
the last patch.

Thanks!
Yijing.

> .
> 


-- 
Thanks!
Yijing


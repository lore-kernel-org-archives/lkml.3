Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbbASCkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:40:07 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:47495 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbASCkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:40:02 -0500
Message-ID: <54BC6E6E.9090200@huawei.com>
Date: Mon, 19 Jan 2015 10:39:42 +0800
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
Subject: Re: [PATCH 09/28] PCI: Separate pci_host_bridge creation out of pci_create_root_bus()
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-10-git-send-email-wangyijing@huawei.com> <11966423.5s0rO0b8cE@wuerfel>
In-Reply-To: <11966423.5s0rO0b8cE@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54BC6E7D.00ED,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 406b3e2a7386748558eafdcf2f0c7ba8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/16 17:34, Arnd Bergmann wrote:
> On Friday 16 January 2015 09:44:07 Yijing Wang wrote:
>> We want to make a generic pci_host_bridge, then we could
>> place common PCI infos like domain number in it. Ripping
>> out pci_host_bridge creation from pci_create_root_bus()
>> make code more better readability. Further more, we could
>> use the generic pci_host_bridge to hold host bridge specific
>> operations like pcibios_root_bridge_prepare().
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>
> 
> I assume this patch is doing the right thing, but the description
> above doesn't really tell me enough to be sure.
> 
> This is supposed to be transparent to the callers, right? If
> so, please mention it explicitly in the text.

Sorry, I will refresh the patch log for better description.

In this series I have no plan to export the pci_create_host_bridge()
to callers, because I think pci_host_bridge_ops could make callers
have the ability to setup the platform specific operations. But if this
is needed, we could introduce another patches to export it.

> 
> Also you don't explain what the list of host bridges is
> used for. Maybe you can split this out into a separate patch
> so you have one patch that just moves code from one file
> to the other but no functional changes, and a second patch
> that exports pci_create_host_bridge and introduces the list,
> with an explanation of what it is used for.
> 

pci_host_bridge_list is used to find out whether the pci_host_bridge
in domain:bus is already existed, I will split the related code
to another patch, thanks.


> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing


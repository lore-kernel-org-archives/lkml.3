Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbASK5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:57:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:53863 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbASK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:57:08 -0500
Message-ID: <54BCE2DA.1000405@huawei.com>
Date: Mon, 19 Jan 2015 18:56:26 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-alpha@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 08/28] PCI: Introduce pci_host_assign_domain_nr() to assign
 domain
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <3026954.09KG7UaUTi@wuerfel> <54BC6894.6060500@huawei.com> <2124926.gSbG0l1jIy@wuerfel>
In-Reply-To: <2124926.gSbG0l1jIy@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54BCE2FD.000B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1c322bc92db2ef358ffedf9f359bf3db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 17:50, Arnd Bergmann wrote:
> On Monday 19 January 2015 10:14:44 Yijing Wang wrote:
>>>> I'm confused: the same code is already part of the PCI tree, but with
>>>> Lorenzo Pieralisi listed as the patch author. The code is good,
>>>> and I acked it in the past, but one of you is (probably by accident)
>>>> misattributing the patch.
>>>>
>>>> Assuming that the patch that is already merged in next is the right
>>>> one, I think you should rebase your series on top of
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git#next
>>>>
>>>> to avoid conflicts like this one.
>>>>
>>>
>>> I think I just got confused because the code duplicates most of
>>> pci_bus_assign_domain_nr(). Maybe this can be done in a better way
>>> by splitting the existing function into 
>>>
>>> static int pci_assign_domain_nr(struct device *)
>>> {
>>>       ... /* most of pci_bus_assign_domain_nr */
>>>
>>>       return domain;
>>> }
>>>
>>> void pci_host_assign_domain_nr(struct pci_host_bridge *host)
>>> {
>>>       host->domain = pci_assign_domain_nr(host->dev.parent);
>>> }
>>>
>>> void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>>> {
>>>       bus->domain_nr = pci_assign_domain_nr(parent);
>>> }
>>>
>>
>> Hi Arnd,
>>    I kept the almost duplicated pci_host_assign_domain_nr() and
>> pci_bus_assign_domain_nr() here for building happy, because now
>> platform specific pci_domain_nr() still exists which may get domain
>> number from pci_bus. pci_bus_assign_domain_nr() will be removed in
>> the last patch.
>>
> 
> I'm not sure I get your point: the approach I showed above seems to have
> the same effect, except it doesn't duplicate code temporarily, which
> makes it less error-prone in case your patch gets merged at the
> same time as another patch that modifies pci_bus_assign_domain_nr.

OK, I got it, will update it, thanks!


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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3JKIXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:23:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3166 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3JKIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:23:42 -0400
Message-ID: <5257B541.9050400@huawei.com>
Date: Fri, 11 Oct 2013 16:22:25 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gavin Shan <shangw@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 3/6] powerpc/pci: use pci_is_pcie() to simplify code
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com> <1378367730-25996-3-git-send-email-wangyijing@huawei.com> <20130906203035.GA27940@google.com> <1381470596.5630.61.camel@pasglop> <20131011061654.GA561@shangw.(null)> <52579BD6.40802@huawei.com> <20131011065329.GA5013@shangw.(null)> <5257A882.1070809@huawei.com> <20131011075642.GA20443@shangw.(null)>
In-Reply-To: <20131011075642.GA20443@shangw.(null)>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In my idea, dev->pcie_cap(here is pci_dev->pcie_cap) will update in set_pcie_port_type() function,
>> and this function always be called after allocate pci device. We get pci_dev by eeh_dev_to_pci_dev(),
>> I think pci_dev has been initialized completely.
>>
>>> This function has possibility to be invoked before that. However,
>>> we don't have the binding (eeh device <-> PCI device) for the case.
>>> So the piece of code shouldn't be running
>>
>> In PCI core, I knew
>>
>> pci_scan_device()
>>   pci_setup_device()
>>       set_pcie_port_type()
>>            pci_dev->pcie_cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>>
>> In powerpc, I also found
>>
>> of_scan_pci_dev()
>>   of_create_pci_dev()
>>       set_pcie_port_type()
>> 	    pci_dev->pcie_cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>>>
>>> However, it's a bit safer to have pci_find_capability(dev, PCI_CAP_ID_EXP)
>>> as well even though we needn't it for 99.9% cases if you agree :-)
>>
>> I agree, this function is not the performance bottleneck,
>> safety is more important. :)
>> So if Bjorn and Benjamin think it's not safe, it's ok to drop it. :)
>>
> 
> No, it's not what I mean. Anyway, "v3" looks good to me.
> At least, it can save PCI-CFG access cycles find locate
> the PCIe capability position :-)

Thanks! :)

> 
> Thanks,
> Gavin
> 
> 
> .
> 


-- 
Thanks!
Yijing


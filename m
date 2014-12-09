Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaLIMYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:24:45 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:53585 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaLIMYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:24:43 -0500
Message-ID: <5486EA00.6080901@huawei.com>
Date: Tue, 9 Dec 2014 20:24:32 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com> <1418069543-21969-3-git-send-email-marc.zyngier@arm.com> <5486585B.40000@huawei.com> <5486C8BA.8030608@arm.com> <5486E3BF.70703@huawei.com> <5486E747.4010804@arm.com>
In-Reply-To: <5486E747.4010804@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Well, this is not supposed to be a perfect solution yet, but instead a
>>> basis for discussion. What I'd like to find out is:
>>>
>>> - What is the minimum granularity for associating a device with its MSI
>>> domain in existing platforms?
>>
>> PCI device, after Gerry's msi irq domain patchset which now in linux-next,
>> in x86, we will find msi irq domain by pci_dev.
> 
> Are you *really* associating the MSI domain on a per pci-device basis?
> That is, you have devices on the same PCI bus talking to different MSI hw?

Yes.

> 
>> I generally agree your first patch which associate basic device with msi irq domain.
>>
>>> - What topology data structures do you use to find out what MSI
>>> controller a device should be matched with?
>>
>> Now only arm and arm64 use msi controller to setup/teardown msi irqs,
>> in arm, now msi controller saved in pci_sys_data, and for arm64, it seems
>> to be saved in pci_bus. For a more common method to find msi controller/irq domain,
>> I prefer pci_dev/device.
> 
> Forget about msi_controller, the whole goal of this series is to make it
> obsolete. On your x86 platform, what how do you identify which MSI
> domain should be associated with a given PCI device? Surely you must
> have a set of data structures or ACPI tables which give you that
> information.

Yes, by ACPI DMAR table.

> 
>>> - What in-tree platform already has this requirements?
>>
>> As mentioned above, x86 does.
> 
> Let me rephrase that in a non-ambiguous manner: can you point me to a
> file implementing this in mainline?

Please refer to arch/x86/kernel/apic/msi.c  native_setup_msi_irqs()  in linux-next tree.

Thanks!
Yijing.

> 
> Thanks,
> 
> 	M.
> 


-- 
Thanks!
Yijing


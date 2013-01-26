Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3AZBZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:25:12 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:57417 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3AZBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:25:08 -0500
Message-ID: <51033057.1080908@huawei.com>
Date: Sat, 26 Jan 2013 09:24:39 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v10 00/11] PCI, ACPI: pci root bus hotplug support / pci
 match_driver
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org> <2072996.JYmST9orI6@vostro.rjw.lan> <CAE9FiQUS56KnvDCF7LUyCkNLcun+3zZ+xGiexca2ej30dRvrQg@mail.gmail.com> <CAErSpo7-XabKQh_Lia9zS9i4Mm=eBV6rRw0ArjXAZBiWYx4uYA@mail.gmail.com>
In-Reply-To: <CAErSpo7-XabKQh_Lia9zS9i4Mm=eBV6rRw0ArjXAZBiWYx4uYA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-1-26 8:04, Bjorn Helgaas wrote:
> On Tue, Jan 22, 2013 at 3:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Jan 22, 2013 at 2:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Monday, January 21, 2013 01:20:41 PM Yinghai Lu wrote:
>>>> It includes
>>>> 1. preparing patches for pci root bus hotadd/hotremove support
>>>> 2. move root bus hotadd from acpiphp to pci_root.c
>>>> 3. add hot-remove support
>>>> 4. add acpi_hp_work to be shared with acpiphp and root-bus hotplug
>>>> 5. add match_driver to add pci device to device tree early but
>>>>    not attach driver for hotplug path.
>>>>
>>>> based on pci/next + pm/acpi-scan
>>>>
>>>> could get from
>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug
>>>>
>>>> -v9: merges several patches together for easy review, requested by Rafael.
>>>> -v10: address comments from Rafael.
>>>>
>>>> Jiang Liu (2):
>>>>   PCI: Fix a device reference count leakage issue in pci_dev_present()
>>>>   PCI: make PCI device create/destroy logic symmetric
>>>>
>>>> Tang Chen (1):
>>>>   PCI, ACPI: debug print for installation of acpi root bridge's
>>>>     notifier
>>>>
>>>> Yinghai Lu (8):
>>>>   PCI, acpiphp: Add is_hotplug_bridge detection
>>>>   PCI: Add root bus children dev's res to fail list
>>>>   PCI: Set dev_node early for pci_dev
>>>>   PCI, ACPI, acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work
>>>>   PCI, acpiphp: Move and enhance hotplug support of pci host bridge
>>>>   PCI, acpiphp: Don't bailout even no slots found yet.
>>>>   PCI: Skip attaching driver in device_add()
>>>>   PCI: Put pci dev to device tree as early as possible
>>>
>>> OK
>>>
>>> Please feel free to add
>>>
>>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> to all of the patches in this series I haven't acked already.
> 
> I first pulled in
> "git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> acpi-scan" again (to pci/acpi-scan2), added your acks, Rafael, and put
> this series on a pci/yinghai-root-bus branch based on pci/acpi-scan2.
> 
> I reworked some of the changelogs a bit, but I don't think I made any
> code changes except that in [10/11] I just inlined the
> pci_bus_attach_device() code rather than making a new function, since
> it's small, there's only one caller, and I didn't think we needed any
> more pci_* and pci_bus_* functions than we already have.
> 
> Let me know if I messed anything up.
Great, so I could rebase my PCI notification related work to this branch.
I'm trying to resolve conflicts between acpi-scan and pci-root-bus-hotplug
last night.

Thanks!

> 
> Bjorn
> 
> .
> 



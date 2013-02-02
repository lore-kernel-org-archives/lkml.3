Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3BBCZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 21:25:24 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4187 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab3BBCZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 21:25:21 -0500
Message-ID: <510C78F5.6050902@huawei.com>
Date: Sat, 2 Feb 2013 10:24:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] acpiphp: create companion ACPI devices before creating
 PCI devices
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com> <CAErSpo5CcEudpbozcu49EOQ4eL2bE40YVNDji7RbSA7Z28y1cw@mail.gmail.com>
In-Reply-To: <CAErSpo5CcEudpbozcu49EOQ4eL2bE40YVNDji7RbSA7Z28y1cw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/2 7:06, Bjorn Helgaas wrote:
> On Wed, Jan 30, 2013 at 9:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> With commit 4f535093cf8f6da8c "PCI: Put pci_dev in device tree as
>> early as possible", companion ACPI devices should be created before
>> creating correspoding PCI devices, otherwise it will break the ACPI
>> PCI binding logic.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>> Hi Bjorn,
>>         This patch set applies to your pci/yinghai-root-bus branch.
>> There are still other potential bugs in the acpiphp driver under
>> investigation. So I will send out these two first to catch up with
>> the 3.9 merging window.
>>         Thanks!
>>         Gerry
> 
> I assume this fixes some sort of user-visible issue with acpiphp.
> What failure does the user see?

Hi Bjorn,
   Before applied this patch, after hot remove and hot add pci device by acpiphp,
we can find firmware_node under the pci device was missed.

Detailed info as bellow:
linux-ha2:/sys/bus/pci/slots # ls /sys/bus/pci/devices/0000\:05\:00.0/ -al
total 0
drwxr-xr-x 3 root root         0 Jan 31 10:19 .
drwxr-xr-x 9 root root         0 Jan 31 10:19 ..
-r--r--r-- 1 root root     65536 Jan 31 10:31 boot_vga
-rw-r--r-- 1 root root     65536 Jan 31 10:31 broken_parity_status
-r--r--r-- 1 root root     65536 Jan 31 10:19 class
-rw-r--r-- 1 root root      4096 Jan 31 10:31 config
-r--r--r-- 1 root root     65536 Jan 31 10:31 consistent_dma_mask_bits
-rw-r--r-- 1 root root     65536 Jan 31 10:31 d3cold_allowed
-r--r--r-- 1 root root     65536 Jan 31 10:19 device
-r--r--r-- 1 root root     65536 Jan 31 10:31 dma_mask_bits
-rw------- 1 root root     65536 Jan 31 10:31 enable
lrwxrwxrwx 1 root root         0 Jan 31 10:31 firmware_node -> ../../../LNXSYSTM:00/device:00/ACPI0004:00/PNP0A08:00/device:07/device:08
-r--r--r-- 1 root root     65536 Jan 31 10:19 irq
-r--r--r-- 1 root root     65536 Jan 31 10:31 local_cpulist
-r--r--r-- 1 root root     65536 Jan 31 10:20 local_cpus
-r--r--r-- 1 root root     65536 Jan 31 10:31 modalias
-rw-r--r-- 1 root root     65536 Jan 31 10:31 msi_bus
-r--r--r-- 1 root root     65536 Jan 31 10:31 numa_node
drwxr-xr-x 2 root root         0 Jan 31 10:31 power
--w--w---- 1 root root     65536 Jan 31 10:31 remove
--w--w---- 1 root root     65536 Jan 31 10:31 rescan
-r--r--r-- 1 root root     65536 Jan 31 10:19 resource
-rw------- 1 root root  16777216 Jan 31 10:31 resource0
-rw------- 1 root root 268435456 Jan 31 10:31 resource1
-rw------- 1 root root 268435456 Jan 31 10:31 resource1_wc
-rw------- 1 root root  33554432 Jan 31 10:31 resource3
-rw------- 1 root root  33554432 Jan 31 10:31 resource3_wc
-rw------- 1 root root       128 Jan 31 10:31 resource5
-rw------- 1 root root    524288 Jan 31 10:31 rom
lrwxrwxrwx 1 root root         0 Jan 31 10:19 subsystem -> ../../../../bus/pci
-r--r--r-- 1 root root     65536 Jan 31 10:19 subsystem_device
-r--r--r-- 1 root root     65536 Jan 31 10:19 subsystem_vendor
-rw-r--r-- 1 root root     65536 Jan 31 10:19 uevent
-r--r--r-- 1 root root     65536 Jan 31 10:19 vendor
linux-ha2:/sys/bus/pci/slots # cd 0
linux-ha2:/sys/bus/pci/slots/0 # cat address
0000:05:00
linux-ha2:/sys/bus/pci/slots/0 # cat power
1
linux-ha2:/sys/bus/pci/slots/0 # echo 0 > power
linux-ha2:/sys/bus/pci/slots/0 # echo 1 > power
linux-ha2:/sys/bus/pci/slots/0 # ls /sys/bus/pci/devices/0000\:05\:00.0/ -al
total 0
drwxr-xr-x 3 root root         0 Jan 31 10:31 .
drwxr-xr-x 9 root root         0 Jan 31 10:19 ..
-r--r--r-- 1 root root     65536 Jan 31 10:31 boot_vga
-rw-r--r-- 1 root root     65536 Jan 31 10:31 broken_parity_status
-r--r--r-- 1 root root     65536 Jan 31 10:31 class
-rw-r--r-- 1 root root      4096 Jan 31 10:31 config
-r--r--r-- 1 root root     65536 Jan 31 10:31 consistent_dma_mask_bits
-rw-r--r-- 1 root root     65536 Jan 31 10:31 d3cold_allowed
-r--r--r-- 1 root root     65536 Jan 31 10:31 device
-r--r--r-- 1 root root     65536 Jan 31 10:31 dma_mask_bits
-rw------- 1 root root     65536 Jan 31 10:31 enable
-r--r--r-- 1 root root     65536 Jan 31 10:31 irq
-r--r--r-- 1 root root     65536 Jan 31 10:31 local_cpulist
-r--r--r-- 1 root root     65536 Jan 31 10:31 local_cpus
-r--r--r-- 1 root root     65536 Jan 31 10:31 modalias
-rw-r--r-- 1 root root     65536 Jan 31 10:31 msi_bus
-r--r--r-- 1 root root     65536 Jan 31 10:31 numa_node
drwxr-xr-x 2 root root         0 Jan 31 10:31 power
--w--w---- 1 root root     65536 Jan 31 10:31 remove
--w--w---- 1 root root     65536 Jan 31 10:31 rescan
-r--r--r-- 1 root root     65536 Jan 31 10:31 resource
-rw------- 1 root root  16777216 Jan 31 10:31 resource0
-rw------- 1 root root 268435456 Jan 31 10:31 resource1
-rw------- 1 root root 268435456 Jan 31 10:31 resource1_wc
-rw------- 1 root root  33554432 Jan 31 10:31 resource3
-rw------- 1 root root  33554432 Jan 31 10:31 resource3_wc
-rw------- 1 root root       128 Jan 31 10:31 resource5
-rw------- 1 root root    524288 Jan 31 10:31 rom
lrwxrwxrwx 1 root root         0 Jan 31 10:31 subsystem -> ../../../../bus/pci
-r--r--r-- 1 root root     65536 Jan 31 10:31 subsystem_device
-r--r--r-- 1 root root     65536 Jan 31 10:31 subsystem_vendor
-rw-r--r-- 1 root root     65536 Jan 31 10:31 uevent
-r--r--r-- 1 root root     65536 Jan 31 10:31 vendor
linux-ha2:/sys/bus/pci/slots/0 #

So after hot add pci device again, we lost the firmware_node link under device.
firmware_node -> ../../../LNXSYSTM:00/device:00/ACPI0004:00/PNP0A08:00/device:07/device:08


> 
>> ---
>>  drivers/pci/hotplug/acpiphp_glue.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>> index bd784ff..acb7af2 100644
>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -839,6 +839,9 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>         if (slot->flags & SLOT_ENABLED)
>>                 goto err_exit;
>>
>> +       list_for_each_entry(func, &slot->funcs, sibling)
>> +               acpiphp_bus_add(func);
>> +
>>         num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
>>         if (num == 0) {
>>                 /* Maybe only part of funcs are added. */
>> @@ -862,9 +865,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>                 }
>>         }
>>
>> -       list_for_each_entry(func, &slot->funcs, sibling)
>> -               acpiphp_bus_add(func);
>> -
>>         pci_bus_assign_resources(bus);
>>         acpiphp_sanitize_bus(bus);
>>         acpiphp_set_hpp_values(bus);
>> --
>> 1.7.9.5
>>
> 
> 


-- 
Thanks!
Yijing


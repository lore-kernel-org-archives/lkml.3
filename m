Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3BAXSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 18:18:07 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:44922 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab3BAXSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 18:18:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5CcEudpbozcu49EOQ4eL2bE40YVNDji7RbSA7Z28y1cw@mail.gmail.com>
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com> <CAErSpo5CcEudpbozcu49EOQ4eL2bE40YVNDji7RbSA7Z28y1cw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Feb 2013 16:17:40 -0700
Message-ID: <CAErSpo7HUxDAaF0qbXDCT7yU8Yv4RuxQmpPXC55uzU0KavQP3Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] acpiphp: create companion ACPI devices before
 creating PCI devices
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 4:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Jan 30, 2013 at 9:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> With commit 4f535093cf8f6da8c "PCI: Put pci_dev in device tree as
>> early as possible", companion ACPI devices should be created before
>> creating correspoding PCI devices, otherwise it will break the ACPI
>> PCI binding logic.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Applied to pci/yinghai-root-bus for v3.9.  Thanks!

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

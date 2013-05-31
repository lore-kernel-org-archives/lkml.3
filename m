Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3EaTS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:18:56 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34374 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3EaTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <51A8CDC7.2050508@gmail.com>
References: <1368536439-19421-1-git-send-email-jiang.liu@huawei.com>
 <1368536439-19421-2-git-send-email-jiang.liu@huawei.com> <20130530173356.GA26075@google.com>
 <3828716.JNCrg8I1Kf@vostro.rjw.lan> <51A8CDC7.2050508@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 31 May 2013 13:18:26 -0600
Message-ID: <CAErSpo5mtYxWkVn+DTT4Sswp0RkWBM=prhtViMJ+KoLpOMY1hw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] ACPI, pci_root: use acpi_handle_print() and
 pr_xxx() to print messages
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:20 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On Fri 31 May 2013 03:51:51 AM CST, Rafael J. Wysocki wrote:
>> On Thursday, May 30, 2013 11:33:56 AM Bjorn Helgaas wrote:
>>> On Tue, May 14, 2013 at 09:00:39PM +0800, Jiang Liu wrote:
>>>> Use acpi_handle_print() and pr_xxx() to print messages in pci_root.c.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>>> Cc: Len Brown <lenb@kernel.org>
>>>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>>>> Cc: linux-acpi@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>  drivers/acpi/pci_root.c | 70 ++++++++++++++++++++++---------------------------
>>>>  1 file changed, 32 insertions(+), 38 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>>> index 91ddfd6..21dda5a 100644
>>>> --- a/drivers/acpi/pci_root.c
>>>> +++ b/drivers/acpi/pci_root.c
>>>> @@ -379,23 +379,24 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>>     struct acpi_pci_root *root;
>>>>     u32 flags, base_flags;
>>>>     bool is_osc_granted = false;
>>>> +   acpi_handle handle = device->handle;
>>>>
>>>>     root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>>>>     if (!root)
>>>>             return -ENOMEM;
>>>>
>>>>     segment = 0;
>>>> -   status = acpi_evaluate_integer(device->handle, METHOD_NAME__SEG, NULL,
>>>> +   status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
>>>>                                    &segment);
>>>>     if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>>>> -           printk(KERN_ERR PREFIX "can't evaluate _SEG\n");
>>>> +           acpi_handle_err(handle, "can't evaluate _SEG\n");
>>>
>>> I previously acked this, but I noticed that we are making a mix of
>>> dev_printk() and acpi_handle_printk() here.  The difference is like this:
>>>
>>>   acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>>>   ACPI: \_SB_.PCI0: ACPI _OSC support notification failed, disabling PCIe ASPM
>>>
>>> I'm not sure which direction we should go here, but I think we should
>>> choose one or the other and use it consistently.  Personally, I think the
>>> internal DSDT names should be available *somewhere*, but not necessarily
>>> used in run-of-the-mill chit-chat.  For that reason, I prefer
>>> dev_printk(), though I have the feeling that Rafael is moving toward
>>> eliminating the struct acpi_device, so he might prefer
>>> acpi_handle_printk().
>>
>> I really don't care that much, but I agree that they should be used
>> consistently.
> Hi Bjorn and Rafael,
>      I will work on this tomorrow. In some cases, only handle is
> available, so we
> could only use acpi_handle_printk(). So I think the directly may be:
> use dev_printk()
> if possible, otherwise use acpi_handle_printk() instead. Is that the
> right way to go?

That sounds good to me.

Bjorn

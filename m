Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbbAISLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:11:22 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:37911 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbbAISLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAPybu_2rrJ8nYqVPf5B99+3=c4CJxAPe8kM2fmRWjJXHYGBe2g@mail.gmail.com>
References: <1417538104-27341-1-git-send-email-ricardo.ribalda@gmail.com>
 <20150109172726.GC6575@google.com> <CAPybu_2rrJ8nYqVPf5B99+3=c4CJxAPe8kM2fmRWjJXHYGBe2g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Jan 2015 12:10:59 -0600
Message-ID: <CAErSpo44=SCV0LgXu3_pgXvAdWKXwWPhRfsesWSL33599D8ZJA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Generate uppercase hex for modalias var in uevent
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 12:08 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Shouldnt this also be backported to stable as Commit 89ec3dcf17fd
> ("PCI: Generate uppercase hex for modalias  interface class")?

Sure, I added that, thanks for noticing.  You can always add the
stable tag yourself when posting the patch, too :)

Bjorn

> On Fri, Jan 9, 2015 at 6:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Dec 02, 2014 at 05:35:04PM +0100, Ricardo Ribalda Delgado wrote:
>>> Some implementations of modprobe fail to load the driver for a PCI device
>>> automatically because the "interface" part of the modalias from the kernel
>>> is lowercase, and the modalias from file2alias is uppercase.
>>>
>>> The "interface" is the low-order byte of the Class Code, defined in PCI
>>> r3.0, Appendix D.  Most interface types defined in the spec do not use
>>> alpha characters, so they won't be affected.  For example, 00h, 01h, 10h,
>>> 20h, etc. are unaffected.
>>>
>>> Print the "interface" byte of the Class Code in uppercase hex, as we
>>> already do for the Vendor ID, Device ID, Class, etc.
>>>
>>> Commit 89ec3dcf17fd ("PCI: Generate uppercase hex for modalias
>>> interface class") fixed only half of the problem. Some udev
>>> implementations relays on the uevent file and not in the modalias file.
>>>
>>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Fixes: d1ded203adf1 ("PCI: add MODALIAS to hotplug event for pci devices")
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>
>> Applied with Greg's ack to pci/enumeration for v3.20, thanks!
>>
>>> ---
>>>
>>> Modified line is >80 char, but I believe that it is better than breaking
>>> the string or indent it bad.
>>>
>>>  drivers/pci/pci-driver.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>>> index 2b3c894..b720e78 100644
>>> --- a/drivers/pci/pci-driver.c
>>> +++ b/drivers/pci/pci-driver.c
>>> @@ -1389,7 +1389,7 @@ static int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
>>>       if (add_uevent_var(env, "PCI_SLOT_NAME=%s", pci_name(pdev)))
>>>               return -ENOMEM;
>>>
>>> -     if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x",
>>> +     if (add_uevent_var(env, "MODALIAS=pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X",
>>>                          pdev->vendor, pdev->device,
>>>                          pdev->subsystem_vendor, pdev->subsystem_device,
>>>                          (u8)(pdev->class >> 16), (u8)(pdev->class >> 8),
>>> --
>>> 2.1.3
>>>
>
>
>
> --
> Ricardo Ribalda

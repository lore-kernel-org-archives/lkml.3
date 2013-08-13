Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab3HMQfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:35:04 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:43439 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757630Ab3HMQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:35:00 -0400
Message-ID: <520A602F.1060003@hurleysoftware.com>
Date: Tue, 13 Aug 2013 12:34:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Wu <lekensteyn@gmail.com>
CC: Nestor Lopez Casado <nlopezcasad@logitech.com>, jkosina@suse.cz,
        benjamin.tissoires@gmail.com, adlr@chromium.org,
        joseph.salisbury@canonical.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <2324751.QaRpZppUQy@al> <520A22DD.3010308@hurleysoftware.com> <1614065.3ZkY1dAtg4@al>
In-Reply-To: <1614065.3ZkY1dAtg4@al>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 11:42 AM, Peter Wu wrote:
> On Tuesday 13 August 2013 08:13:17 Peter Hurley wrote:
>> On 08/12/2013 05:54 PM, Peter Wu wrote:
>>> On Thursday 18 July 2013 16:28:01 Peter Hurley wrote:
>>>> Before we revert to using the workaround, I'd like to suggest that
>>>> this new "hidden" problem may be an interaction with the xhci_hcd host
>>>> controller driver only.
>>>>
>>>> Looking at the related bug, the OP indicates the machine only has
>>>> USB3 ports. Additionally, comments #7, #100, and #104 of the original
>>>> bug report add additional information that would seem to confirm
>>>> this suspicion.
>>>>
>>>> Let me add I have this USB device running on the uhci_hcd driver
>>>> with or without this workaround on v3.10.
>>>
>>> This problem does not seem specific to xhci, uhci seems also effected.
>>
>> If true, it would certainly help to have a bug report confirming uhci
>> failure from a bare-metal system which contained:
>> 1) kernel version
>> 2) complete dmesg output
>> 3) lsusb -v output
>> 4) lsmod output
>> 5) usbmon capture from a plug attempt
>
> I was too fast in drawing a conclusion, besides the kernel I also upgraded
> some other packages. Today the issue also showed up in 3.9.9 + updated
> packages.
>
> When checking the dmesg, the issue solved by this patch did not occur (the
> enumeration was successful).

Thanks for double-checking.

>>> Today I
>>> upgraded a system (running Arch Linux) from kernel 3.9.9 to 3.10.5. After
>>> a
>>> reboot to 3.10.5, things broke. The setup:
>>>
>>> - There are two USB receivers plugged into USB 1.1 ports (different buses
>>> according to lsusb, uhci), each receiver is paired to a K360 keyboard.
>>> - One of the receivers are passed to a QEMU guest with -usbdevice
>>> host:$busid. $devid. This keyboard is working (probably because QEMU
>>> performed a reset). - Since 3.10.5, the keyboard that is *not* passed to
>>> the QEMU guest is not functioning on reboot.
>>>
>>> After closing the QEMU guest, the USB bus gets reset(?) after which the
>>> other keyboard suddenly gets detected. I had only booted 3.10.5 twice
>>> before rolling back to 3.9.9, both boots triggered the issue. Do I need
>>> to provide a usbmon, lsusb, dmesg and/ or other details from 3.10.5?
>>
>> Do both keyboards work on bare metal? Seems like this problem might be
>> specific to qemu (or kvm) and you may get more insight on those lists.
>
> I haven't tested that, the system automatically boots into openbox + QEMU.
> Previously, both keyboards worked on bare metal, so I think it still works.
>
>>> Note that there are other Arch Linux users who have reported issues[1][2]
>>
>> Unfortunately, not even one user in the referenced reports identified
>> the usb hub the receiver was plugged into.
>
> I've asked it now.

Thanks. And if someone has a uhci failure, filing a new bug on
bugzilla.kernel.org _and_ posting to linux-usb@ and
linux-input@vger.kernel.org improves the chances of the right
people seeing the problem. [xhci already has several reports plus I
subscribed to the kernel bug linked from the ArchLinux bug report.]

>>> since upgrading to 3.10.z. Triggering a re-enumeration by writing the
>>> magic
>>> HID++ message[3] makes the paired devices appear again (as reported in
>>> forums[1], I haven't tried this on the affected UHCI machine).
>>>
>>> While the underlying bug is fixed, can this patch be forwarded to stable?
>>> I see that 3.10.6 has been released, but still without this patch.
>>
>> This is still a workaround and not really a fix for the underlying bug.
>
> I meant to say, "while the underlying bug is *being* fixed". Anyway, can this
> patch be applied to 3.10?

That's really Jiri's call. TBH, I can't blame him for wanting to shake this
out in 3.11 before pushing to stable.

> Sorry for the confusion with uhci, looking further it seems that the wrong USB
> receiver is being passed to QEMU. It's not a kernel issue, perhaps I can blame
> libusbx.

No apologies necessary.

Regards,
Peter Hurley


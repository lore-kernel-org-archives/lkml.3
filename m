Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3FGAEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:04:12 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:47256 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3FGAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:04:09 -0400
Message-ID: <51B12375.5090508@fold.natur.cuni.cz>
Date: Fri, 07 Jun 2013 02:04:05 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Michal Marek <mmarek@suse.cz>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
References: <s5h38vqjhk6.wl%tiwai@suse.de> <514A02E2.9030700@fold.natur.cuni.cz> <s5hobedq3nv.wl%tiwai@suse.de>
In-Reply-To: <s5hobedq3nv.wl%tiwai@suse.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 20 Mar 2013 19:41:38 +0100,
> Martin Mokrejs wrote:
>>
>> Hi Takashi,
>>   would you please describe your test system in more detail? How
>> about 'lspci -tv'? And 'lsusb -v' of the broken device?
> 
> I left the machine in my office, so I'll give details tomorrow.
> It's a Realtek 5249 PCI-e card reader, and this appears as a PCI
> device once when registered by pciehp.  At cold boot, it doesn't
> appear in lspci.  It appears only when you insert the card.  Also,
> this device is no USB.  It's supported by mfd/rtsx_pci driver in 3.9.
> 

>> If I have Realtek MediaCardReader enabled in BIOS, no card in it, coldboot, and hot
>> insert an ExpressCard into the slot, the Realtek MediaCardReader pops up in dmesg as
>> a new PCI device. How about you?
> 
> The device is hotplugged only when the option of my patch is enabled,
> i.e. overriding the surprise capability check.
> 
>> My card does NOT show in lspci (maybe because I never plugged in a data card into it) but does show in lsusb:
> 
> So, it's a completely different case...
> 
>>
>> Bus 002 Device 005: ID 0bda:0138 Realtek Semiconductor Corp. RTS5138 Card Reader Controller
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               2.00
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0 
>>   bDeviceProtocol         0 
>>   bMaxPacketSize0        64
>>   idVendor           0x0bda Realtek Semiconductor Corp.
>>   idProduct          0x0138 RTS5138 Card Reader Controller
>>   bcdDevice           38.82
>>   iManufacturer           1 Generic
>>   iProduct                2 USB2.0-CRW
>>   iSerial                 3 20090516388200000
>>
>>
>> Can you try coldboot without a media card inserted before power up without
>> your patch and check whether the CardReader pops up after you plugin some
>> ExpressCard into an ExpressCardSlot (not the CardReader)? I presume it is
>> a laptop. ;-)
> 
> When you boot without the card, there is no PCI device.  Triggering
> PCI bus rescan also doesn't expose it.  But, when you insert the card,
> you'll get the notification in pciehp (seeing "Card present on Slot"
> message), but pciehp doesn't do anything right now unless the
> surprising bit is set.  The device may appear if you trigger the PCI
> bus rescan at this moment, too, though.
> 
>> 2. Is the hotplug broken also under acpiphp? And again, does it get detected
>> once you plugin some card into an ExpressCard slot?
> 
> acpiphp doesn't load on this machine.

While we concluded above that I have a different card (USB-hooked Realtek card)
I need since about 3.5 kernel pcie_aspm=off to get acpiphp working. It does not
work for all express cards but maybe this will help you to get *acpiphp* recognize
the slot? Note: the same kernel command line pcie_aspm=off breaks *pciehp* on
my laptop, so don't forget to delete it from grub.conf if you want to stick
with *pciehp* (if your hardware is prone to hit same bug like me:
https://bugzilla.kernel.org/show_bug.cgi?id=59391 .

Just in case you could switch to acpiphp. ;)
Martin

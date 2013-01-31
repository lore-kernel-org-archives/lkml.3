Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3AaNGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:06:06 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:39462 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753471Ab3AaNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:06:02 -0500
Message-ID: <510A6C36.1010906@fold.natur.cuni.cz>
Date: Thu, 31 Jan 2013 14:05:58 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com>
In-Reply-To: <510A5F0E.6010100@googlemail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Clayton wrote:
> Hi Martin,
> 
> On 01/28/13 21:02, Martin Mokrejs wrote:
>> Hi Chris,
>>
>> Chris Clayton wrote:
>>> Hi Martin,
>>>
>>> On 01/28/13 12:12, Martin Mokrejs wrote:
>>>> Chris Clayton wrote:

>>>
>>> I've struggled with this a little. For some reason, the expresscard
>>> doesn't always stay properly inserted in the slot when I insert it.
>>> Now that hotplug is working, the modules are being loaded and when
>>> the card pops out again, I get an oops because, of course, the driver
>>> is running and the card disappears. Perhaps the driver can be made a
>>> bit more robust to sudden disappearance of the card. I'll report the
>>
>> Yes, I had or maybe still have same issues here. I used to get an Oops
>> for sata_sil24 card weird behavior for USB3.0 NEC-based card. It was
>> fine always for a VIA-based firewire card and serial PL2303-based one.
>> I found out it is better if a usb device is connected to the USB card
>> because if that slips out then the libata layer quickly realizes that.
>> If there was no device connected, the usb waits too long before it removes
>> the usb hub from the system. And if you plugin the card meanwhile
>> back into the slot, weird thing happen.
>>
> My usb3 expresscard device has arrived and I get an oops with that
> too, if I remove it without unloading the driver first. I guess it
> shouldn't be a surprise that the driver isn't expecting the device to
> disappear.

I avoided the oopses when a USB device to connected to the express card.
Nevertheless, you should report it to linux-usb and linux-pci mailing lists,
along with the oops stacktrace (under a new thread). Maybe you suffer from
another Oops.

> 
> As I mentioned, I have some trouble with the WinTV-HVR-1400 card,
> which sometimes pops out again, if I push it into the slot too hard
> (but I'm geeting better at that with practice). So what I've done
> (with the usb3 card too) to avoid the oopsen is blacklist the driver
> in /etc/modprobe.d/blacklist.conf and then load them when I'm sure
> the card is properly inserted. Not exactly hotplug, but at least I
> don't have to reboot because of an oops- and it's not something I'm
> doing several times an hour.

Yeah, i also my way around - not fiddle much with the cards and if they
slip out during insertion, don't re-plug them too quickly (at least with
the USB3 card and SATA card I had problems).

BTW, if you remove a card, you are supposed to push the card into the slot
so it gets ejected. Do not just pull it out (what I did in the beginnings).
I was told that is not the right way (probably affects the PresDet status).

Martin

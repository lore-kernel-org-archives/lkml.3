Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3KWA6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:58:34 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22096 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3KWA6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:58:33 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-ba-528ffdb7e9e7
Message-id: <528FFDB4.3030501@samsung.com>
Date: Fri, 22 Nov 2013 17:58:28 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: Linux 3.13-rc1 is out
References: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
In-reply-to: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9hX93tf/uDDGbOUrK4vGsOm8XXnw4W
	j/resjswe+ycdZfd48SM3ywenzfJBTBHcdmkpOZklqUW6dslcGU0N75mKXigWtH0qJW9gXGx
	XBcjJ4eEgInE79+X2SFsMYkL99azdTFycQgJLGOU+Lqmix3C6WWS2HuoiwmkSkhgI6PEytuK
	IDavgJbExwe7wOIsAqoSj+7tZAax2QTUJT6/3sEOUS8n0bRkNVhcVCBC4ujqZ6wQvYISPybf
	YwFZICJwgFGibWcfUIKDQ1hASeLaNRGI3gCJG/cvMYLYnALBEhv/zATbxSxgJvGoZR0zhC0v
	sXnNW2aIemWJP5dPMYGMkRBQlNi+2moCo/AsJNtmIemehaR7ASPzKkax0uLkguKk9NQKY73i
	xNzi0rx0veT83E2MkICv2cF476vNIUYBDkYlHt4dln1BQqyJZcWVuYcYJTiYlUR457/uDxLi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAKPT7od60WVF2mlwZM5RMp0Q8KVmqwZ50zGE1n9kX9hvc
	j91Wuf6xvZRnxT1XXO3bB7tMczMN9UdeL1OK21LL2x7cmXlQotyqnSUyjUfO0jOsPXlz48xe
	R/k/MSWrTtzT7RRM81wnb/q9b0HvI0ddhjnl6+9N+HbHz3bTtb/r4hvT35k6bzirxFKckWio
	xVxUnAgAzPjJ0FYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 01:36 PM, Linus Torvalds wrote:
> So you had an extra week to prepare your pull requests, and if you
> were planning on sending it in the last two days thinking I'd close
> the merge window on Sunday as usual, I can only laugh derisively in
> your general direction, and call you bad names. Because I'm not
> interested in your excuses. I did warn people about this in the 3.12
> release notes. As it was, there were a few people who cut it fairly
> close today. You know who you are.
>
> If there are pull requests I missed (due to getting caught in spam
> filters, or not matching my normal search patterns), and you think you
> sent your pull request in time but it got overlooked, ping me -
> because I don't have anything pending I know about, but mistakes
> happen.
>
> Talking about mistakes... I suspect it was a mistake to have that
> extra week before the merge window opened, and I probably should just
> have done a 3.12-rc8 instead. Because the linux-next statistics look
> suspicious, and we had extra stuff show up there not just in that
> first week. Clearly people took that "let's have an extra week of
> merge window" and extrapolated it a bit too much. Oh, well. Live and
> learn.
>
> Anyway, other than that small oddity, this was a fairly normal merge
> window. By patch size we had a pretty usual ~55% drivers, 18%
> architecture code, 9% network updates, and the rest is spread out (fs,
> headers, tools, documentation). Featurewise, the big ones are likely
> the nftables and the multi-queue block layer stuff, but depending on
> your interests you might find all the incremental updates to various
> areas interesting. There are some odd ones in there (LE mode Powerpc
> support..)
>
> Go forth and test, and start sending me regression fixes. And really,
> if you didn't send me your pull request in time, don't whine about it.
> Because nobody likes a whiner.
>

3.13-rc1 fails to boot on Samsung Series 9. 3.12.1 is fine and the last 
mainline kernel that worked on it was from Nov 14th. It failed to mount 
/boot and after doing a manually mounting it, it came up and didn't 
detect USB mouse. Looking at the dmesg differences in dmesg, looks like 
usb probe fails on USB mouse. I will start a bisect and let you know 
what I find.

dmesg 3.13-rc1:

    63.637083] PM: Adding info for usb:2-1:1.0
[   63.637128] driver: '2-1': driver_bound: bound to device 'usb'
[   63.637136] bus: 'usb': really_probe: bound device 2-1 to driver usb
[  123.660457] usb 2-1: USB disconnect, device number 3
[  123.660505] bus: 'usb': remove device 2-1:1.0
[  123.660508] PM: Removing info for usb:2-1:1.0
[  123.661718] bus: 'usb': remove device 2-1
[  123.661724] PM: Removing info for usb:2-1
[  125.143833] usb 2-1: new low-speed USB device number 4 using xhci_hcd
[  125.190924] usb 2-1: New USB device found, idVendor=17ef, idProduct=6019
[  125.190928] usb 2-1: New USB device strings: Mfr=0, Product=2, 
SerialNumber=0
[  125.190930] usb 2-1: Product: Lenovo Optical USB Mouse
[  125.191042] bus: 'usb': add device 2-1
[  125.191054] PM: Adding info for usb:2-1
[  125.191081] bus: 'usb': driver_probe_device: matched device 2-1 with 
driver usb
[  125.191084] bus: 'usb': really_probe: probing driver usb with device 2-1
[  125.191097] usb 2-1: ep 0x81 - rounding interval to 64 microframes, 
ep desc says 80 microframes
[  125.201952] bus: 'usb': add device 2-1:1.0
[  125.201959] PM: Adding info for usb:2-1:1.0
[  125.202010] driver: '2-1': driver_bound: bound to device 'usb'
[  125.202019] bus: 'usb': really_probe: bound device 2-1 to driver usb

dmesg 3.12.1:


[    5.562700] bus: 'usb': add driver usbhid
[    5.562790] bus: 'usb': driver_probe_device: matched device 2-1:1.0 
with driv
er usbhid
[    5.562794] bus: 'usb': really_probe: probing driver usbhid with 
device 2-1:1
.0
[    5.575965] driver: '2-1:1.0': driver_bound: bound to device 'usbhid'
[    5.575971] bus: 'usb': really_probe: bound device 2-1:1.0 to driver 
usbhid
[    5.575998] usbcore: registered new interface driver usbhid
[    5.576000] usbhid: USB HID core driver
[    5.601326] input: Lenovo Optical USB Mouse as 
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb2/2-1/2-1:1.0/input/input6
[    5.601796] hid-generic 0003:17EF:6019.0001: input,hidraw0: USB HID 
v1.11 Mouse [Lenovo Optical USB Mouse] on usb-0000:03:00.0-1/input0
[    5.670722] bus: 'usb': add driver btusb
[    5.670736] bus: 'usb': driver_probe_device: matched device 1-1.5:1.0 
with driver btusb
[    5.670739] bus: 'usb': really_probe: probing driver btusb with 
device 1-1.5:1.0

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3KGIKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:10:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63927 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3KGIKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131106102838.347b005c@voldemort.scrye.com>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
	<CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
	<CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
	<5270C549.30201@gmail.com>
	<alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
	<CAFv23Qkbkh2UGv1fFRApg1nCP5ysvBLnLeSW19JLeAfDmbJEsA@mail.gmail.com>
	<20131106102838.347b005c@voldemort.scrye.com>
Date: Thu, 7 Nov 2013 16:10:07 +0800
Message-ID: <CAFv23Q=7L=PqV88XhEMiRfZ+5ZzNWUDXqP3TSpgNwvFvk4sTpw@mail.gmail.com>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
From: AceLan Kao <acelan.kao@canonical.com>
To: Kevin Fenzi <kevin@scrye.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Nikolai Kondrashov <spbnick@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

http://people.canonical.com/~acelan/elan_touchscreen/
Here are the kernels, please test them one by one and tell me which one works.
As your description, the first one should work, and the second one doesn't,
I just want to make sure that, so I build the rc6 and rc7 kernel to test.
Thanks.

Best regards,
AceLan Kao.

2013/11/7 Kevin Fenzi <kevin@scrye.com>:
> On Wed, 6 Nov 2013 09:44:11 +0800
> AceLan Kao <acelan.kao@canonical.com> wrote:
>
>> Hi,
>>
>> Sorry, no thoughts about this.
>> If Kevin would like to try, I can bisect the kernel and build the
>> Ubuntu .deb package for him.
>> But like I say above, those 4 commits doesn't look like to lead to the
>> problem, so I'll try to bisect the whole kernel.
>>
>> % git bisect start v3.12-rc7 v3.12-rc6
>> Bisecting: 165 revisions left to test after this (roughly 7 steps)
>> [edd31476011052d8f6591a3194ba0716b0cea681] bnx2x: Set NETIF_F_HIGHDMA
>> unconditionally
>
> Yeah, I can try and do so this weekend. To busy during the week to get
> very far on this.
>
> Also, it seems like on some boots it just never works, but on others It
> does finally work:
>
> [ 3238.722796] usb 2-7: new full-speed USB device number 127 using xhci_hcd
> [ 3238.735177] usb 2-7: New USB device found, idVendor=04f3, idProduct=016f
> [ 3238.735183] usb 2-7: New USB device strings: Mfr=4, Product=14, SerialNumber=0
> [ 3238.735185] usb 2-7: Product: Touchscreen
> [ 3238.735187] usb 2-7: Manufacturer: ELAN
> [ 3238.735539] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
> [ 3238.743682] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input368
> [ 3238.744505] hid-multitouch 0003:04F3:016F.00B4:
> input,hiddev0,hidraw1: USB HID v1.10 Device [ELAN Touchscreen] on
> usb-0000:00:14.0-7/input0
>
> so, 3238 seconds after boot, with 127 tries it started working on this boot.
>
> I'll try and isolate it this weekend. Thanks for the attention everyone.
>
> kevin
> --
>>
>> Best regards,
>> AceLan Kao.
>>
>> 2013/11/5 Jiri Kosina <jkosina@suse.cz>:
>> > On Wed, 30 Oct 2013, Nikolai Kondrashov wrote:
>> >
>> >> > It's hard to believe that those quirks will lead to the problem.
>> >> > And actually, there are 4 new commits introduced to -rc7, and 3
>> >> > of them are quirks.
>> >> >
>> >> > % git log --pretty=oneline v3.12-rc6..v3.12-rc7 drivers/hid
>> >> > 86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add
>> >> > LEGO-wiimote VID ad0e669b922c7790182cf19f8015b30e23ad9499 HID:
>> >> > Fix unit exponent parsing again
>> >> > 684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for
>> >> > SiS Touchscreen
>> >> > 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
>> >> > Synaptics Large Touchccreen
>> >> >
>> >> > CC'd Nikolai, since his commit changes the protocol.
>> >>
>> >> My change is very unlikely to produce such problems. It changes
>> >> calculation of axes resolution at the time the report descriptor
>> >> is processed. The results of the calculation are not used by the
>> >> kernel, AFAIK, but only by userspace drivers. The results should
>> >> not be used to affect the interactions with the device, but only
>> >> the interpretation of the reports (again, in userspace), and even
>> >> that is barely done currently.
>> >>
>> >> Please try reverting that particular commit and see if it affects
>> >> the behavior.
>> >
>> > AceLan,
>> >
>> > do you have any update, please?
>> >
>> > --
>> > Jiri Kosina
>> > SUSE Labs
>>
>

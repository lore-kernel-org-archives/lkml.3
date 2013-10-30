Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3J3BlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:41:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3J3BlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:41:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
	<CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
Date: Wed, 30 Oct 2013 09:41:06 +0800
Message-ID: <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
From: AceLan Kao <acelan.kao@canonical.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Kevin Fenzi <kevin@scrye.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Nikolai Kondrashov <spbnick@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's hard to believe that those quirks will lead to the problem.
And actually, there are 4 new commits introduced to -rc7, and 3 of
them are quirks.

% git log --pretty=oneline v3.12-rc6..v3.12-rc7 drivers/hid
86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add LEGO-wiimote VID
ad0e669b922c7790182cf19f8015b30e23ad9499 HID: Fix unit exponent parsing again
684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for SiS Touchscreen
8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
Synaptics Large Touchccreen

CC'd Nikolai, since his commit changes the protocol.

Best regards,
AceLan Kao.

2013/10/29 Josh Boyer <jwboyer@fedoraproject.org>:
> On Mon, Oct 28, 2013 at 5:02 PM, Kevin Fenzi <kevin@scrye.com> wrote:
>> Greetings.
>>
>> I have a lenovo yoga 2 pro.. it has a ELAN Touchscreen.
>>
>> In 3.12rc5 it was detected and works.
>> in 3.12rc6 it was detected and works.
>>
>> Sometime after the rc6 timeframe it stopped working. It doesn't work with
>> rc7.
>>
>> In dmesg I get:
>>
>> [  159.519663] usb 2-7: New USB device found, idVendor=04f3, idProduct=016f
>> [  159.519681] usb 2-7: New USB device strings: Mfr=4, Product=14, SerialNumber=0
>> [  159.519683] usb 2-7: Product: Touchscreen
>> [  159.519685] usb 2-7: Manufacturer: ELAN
>> [  159.519901] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
>> [  159.528027] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input20
>> [  159.528544] hid-multitouch 0003:04F3:016F.000A: input,hiddev0,hidraw1: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-7/input0
>> [  161.601423] usb 2-7: USB disconnect, device number 71
>> [  161.896828] usb 2-7: new full-speed USB device number 72 using xhci_hcd
>> [  163.991296] usb 2-7: unable to read config index 0 descriptor/start: -71
>> [  163.991301] usb 2-7: can't read configurations, error -71
>> [  164.143686] usb 2-7: new full-speed USB device number 73 using xhci_hcd
>> [  166.239273] usb 2-7: unable to read config index 0 descriptor/start: -71
>> [  166.239278] usb 2-7: can't read configurations, error -71
>> [  166.392576] usb 2-7: new full-speed USB device number 74 using xhci_hcd
>> [  168.487051] usb 2-7: unable to read config index 0 descriptor/start: -71
>> [  168.487058] usb 2-7: can't read configurations, error -71
>> [  168.640308] usb 2-7: new full-speed USB device number 75 using xhci_hcd
>> [  170.734850] usb 2-7: unable to read config index 0 descriptor/start: -71
>> [  170.734856] usb 2-7: can't read configurations, error -71
>> [  170.734927] hub 2-0:1.0: unable to enumerate USB device on port 7
>> [  171.022134] usb 2-7: new full-speed USB device number 76 using xhci_hcd
>> [  173.116744] usb 2-7: unable to read config index 0 descriptor/start: -71
>> [  173.116750] usb 2-7: can't read configurations, error -71
>> [  173.269840] usb 2-7: new full-speed USB device number 77 using xhci_hcd
>> [  173.282520] usb 2-7: New USB device found, idVendor=04f3, idProduct=016f
>> [  173.282526] usb 2-7: New USB device strings: Mfr=4, Product=14, SerialNumber=0
>> [  173.282528] usb 2-7: Product: Touchscreen
>> [  173.282530] usb 2-7: Manufacturer: ELAN
>> [  173.282782] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
>> [  173.290920] input: ELAN Touchscreen
>> as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input21
>>
>> So it seems to be bouncing in and out (but never long enough to actually work).
>>
>> Could be a regression in xhci_hcd?
>
> Hm.  There were no changes in drivers/usb from -rc6 to -rc7, so if
> -rc6 works then I doubt it's xhci_hcd.  There were two touchscreen
> quirks added between those two rcs though, so perhaps one of those
> broke this.
>
> 684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for SiS Touchscreen
> 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
> Synaptics Large Touchccreen
>
> CC'd AceLan and Jiri.
>
> josh

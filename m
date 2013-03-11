Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3CKSDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:03:43 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36517 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <513D968C.1060905@ladisch.de>
References: <1362973920-4942-1-git-send-email-helstroom@google.com>
	<513D968C.1060905@ladisch.de>
Date: Mon, 11 Mar 2013 11:03:42 -0700
Message-ID: <CAOcFWma6fMqwqzMxFfCM7hOqk04FBk9JkKZjwekki_GFUR2jSQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND] Add a USB audio quirk for the NuForce UDH-100 device.
From: Dave Helstroom <helstroom@google.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, damien@zamaudio.com,
        pete.leigh@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2013 01:32, Clemens Ladisch <clemens@ladisch.de> wrote:
> David Helstroom wrote:
>> Interface 1 does not exist
>
> Then it doesn't need a quirk, does it?

Perhaps that's the case. I just know that without
QUIRK_IGNORE_INTERFACE for ifnum 1, the kernel refuses to properly
configure the output device. From dmesg without this patch:
[ 3254.192225] usb 1-1: new high-speed USB device number 6 using ehci_hcd
[ 3254.343554] usb 1-1: config 1 has an invalid interface number: 3 but max is 2
[ 3254.343558] usb 1-1: config 1 has an invalid interface number: 3 but max is 2
[ 3254.343562] usb 1-1: config 1 has an invalid interface number: 3 but max is 2
[ 3254.343565] usb 1-1: config 1 has an invalid interface number: 3 but max is 2
[ 3254.343568] usb 1-1: config 1 has no interface number 1
[ 3254.345988] input: Nuforce Inc., Nuforce 192k USB DAC as
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input10
[ 3254.346202] generic-usb 0003:16D0:0631.0007: input,hidraw0: USB HID
v1.00 Device [Nuforce Inc., Nuforce 192k USB DAC] on
usb-0000:00:1a.7-1/input0
[ 3254.355970] Audio class v2 interfaces need an interface association
[ 3254.355988] snd-usb-audio: probe of 1-1:1.2 failed with error -5
[ 3254.356045] usbcore: registered new interface driver snd-usb-audio

>> and Interface 0 should be ignored.
>
> Why?
>
> If the driver doesn't like something in interface 0, that bug should be
> fixed.
>
> What is the output of "lsusb -v" for this device?

I've put up the relevant output on: http://pastebin.com/i4wpQ35B
Note that I'm testing on an older kernel here (3.2.5), so perhaps a
more fundamental fix has already made its way into the USB audio
stack. I'll arrange to test on a more recent kernel too.

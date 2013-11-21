Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3KUDU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:20:27 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54539 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KUDUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1311191533200.6657@pobox.suse.cz>
References: <20131029145139.GA2788@hercules>
	<alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
	<CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com>
	<527BB695.9040209@redhat.com>
	<alpine.LNX.2.00.1311191533200.6657@pobox.suse.cz>
Date: Thu, 21 Nov 2013 11:20:03 +0800
X-Google-Sender-Auth: r0Mwq1VRGknDcmCjoEdGjJG4oF0
Message-ID: <CALcaVOmCAV8XeURJ5UpWfaFXoj+bz6DZ1NgAt7Xiv5pfEynRFQ@mail.gmail.com>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer dereference
From: James Henstridge <james.henstridge@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 7 Nov 2013, Benjamin Tissoires wrote:
>
>> >> [ adding some more CCs ]
>> >>
>> >> Okay, so apparently we didn't register with input, but only hiddev /
>> >> hidraw.
>> >>
>> >> appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
>> >>
>> >> Therefore ->input_configured() callback has never been called, and thus we
>> >> oops due to appleir->input_dev being NULL when the first raw event is
>> >> reported.
>> >>
>> >> Could you please provide report descriptor of the device?
>> >>
>> >> The driver apparently relies on it being registered with hid-input, but
>> >> for some reason that doesn't happen.
>> >
>> > Here is the relevant lsusb output that I think contains what you're
>> > asking for (I had to unbind usbhid for it to include the descriptor):
>> >
>> > Bus 005 Device 003: ID 05ac:8240 Apple, Inc. Built-in IR Receiver
>> > Device Descriptor:
>> >   bLength                18
>> >   bDescriptorType         1
>> >   bcdUSB               2.00
>> > ...
>>
>> Ok, thanks for the report. Could you please test the following patch
>> which should solve your problem (hopefully)?
>
> James,
>
> any reults from testing Benjamin's patch, please?

Sorry for the delays in testing out the patch.  I have tried a kernel
with the patch applied, and can no longer reproduce the oops.  The
hid-appleir driver appears to be working correctly, generating key
press events in response to the remote, and LIRC functions correctly
via hiddev.

Thanks for the everyone's help with this.

James.

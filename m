Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab3BYKTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:19:03 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:65337 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3BYKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:19:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130220202531.GA1413@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
	<1360334256-22127-7-git-send-email-benjamin.tissoires@gmail.com>
	<20130220202531.GA1413@polaris.bitmath.org>
Date: Mon, 25 Feb 2013 11:18:58 +0100
Message-ID: <CAN+gG=G5QpJxiVRBaU1Z9UeSAoTiezcPyCrvC2jyzopzhFnXqA@mail.gmail.com>
Subject: Re: [PATCH 6/7] HID: multitouch: remove usbhid dependency
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Wed, Feb 20, 2013 at 9:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Since removing the transport layer dependency has a rationale, it
> might be good to mention that here.

Ok, will do.

>
> Also, what about the explicit usb dependency, was that going to be
> moved to a usbhid quirk?

Currently, the USB dependency is protected by a check on the BUS.
The problem is that the BUS can be faked (by uhid). So yes, I'll add a
quirk under usbhid for those devices.

Cheers,
Benjamin

>
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 32258ba..184ac0a 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -32,7 +32,6 @@
>>  #include <linux/slab.h>
>>  #include <linux/usb.h>
>>  #include <linux/input/mt.h>
>> -#include "usbhid/usbhid.h"
>>
>>
>>  MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
>> @@ -907,7 +906,7 @@ static int mt_resume(struct hid_device *hdev)
>>
>>       intf = to_usb_interface(hdev->dev.parent);
>>       interface = intf->cur_altsetting;
>> -     dev = hid_to_usb_dev(hdev);
>> +     dev = interface_to_usbdev(intf);
>>
>>       /* Some Elan legacy devices require SET_IDLE to be set on resume.
>>        * It should be safe to send it to other devices too.
>> --
>> 1.8.1
>>
>
> Thanks,
> Henrik

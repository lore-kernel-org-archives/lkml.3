Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3A1QPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:15:23 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62173 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1QPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:15:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130128152324.GA3481@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
	<20130128152324.GA3481@polaris.bitmath.org>
Date: Mon, 28 Jan 2013 17:15:17 +0100
Message-ID: <CAN+gG=Gv8CUF2zf2=7LgnnhMqzCfgiinJ5=FdkS1CPZQ1PF4Og@mail.gmail.com>
Subject: Re: [PATCH 00/25] Support of Nexio 42" and new default class for hid-multitouch
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

On Mon, Jan 28, 2013 at 4:23 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> finally, I managed to send a new bunch of patches. Sorry for the delay from the
>> previous version, but meanwhile, I implemented an automatic regressions tests
>> for hid device [1].
>> So this series seems pretty big, but it does not break any known devices (I ran
>> 40 successful tests for this series)[2].
>
> Thanks for the patches.

And thanks for reviewing.

>
>> To sum up:
>> - Nexio devices were problematic in the sense they use out of range values for
>> some of the fields, and consider that the driver won't treat the extra touches
>> based on the reported contact count.
>
> Problematic device, but I think we should add a new event function
> which gives all values at the same time, since those are already
> present in the core. It seems this will solve the current problem as
> well as many older workarounds.

yeah, makes sense. I think it would also allows us to simplify the
logic of hid-multitouch by removing some of the states we have in it.

>
>> - fortunately, this behavior (relying on contact count) is compatible with all
>> the devices I know, which leads to think that this is how the Windows 7/8 driver
>> manage to handle such a different bunch of devices.
>
> This is a nice observation. IIRC, we used to rely more on contact
> count in the old drivers.
>
>> - thanks to the automatic testing, I was able to fix broken devices
>> (Sharp LC-20FE1-W screen 04dd:9681, Sitronix 1403:5001 and Cando 2087:0a02)
>> and optimize many others. In order to allow a bisection to be done, I split
>> the patches in many different ones, one per device type.
>
> Great tool, thank you Benjamin.

Once I will do the work on the suppression of usbhid direct use, we
also could rely on that for every HID devices, not only
hid-multitouch.

>
>> - finally, I changed the default class in order to handle the new devices in a
>> better way.
>
> Old wisdom says differently. ;-)

No: old wisdom says the exact same thing :) I did not break the
current supported devices. I _kept_ the old default class for all the
current supported devices, and I used the new default class only for
the new devices, the  one that are not registered.

Cheers,
Benjamin

>
> Thanks,
> Henrik

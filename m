Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbaAIVXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:23:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbaAIVX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:23:29 -0500
Message-ID: <52CF1327.3090705@redhat.com>
Date: Thu, 09 Jan 2014 16:22:47 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew de los Reyes <andrew-vger@gizmolabs.org>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] HID logitech DJ fixes and preps for enabling extended
 features
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com> <CAG_cf+eYoK--k=z+f5xQBx0FP3_z5sbszrSZ1qYq7jR_Zi9Vaw@mail.gmail.com>
In-Reply-To: <CAG_cf+eYoK--k=z+f5xQBx0FP3_z5sbszrSZ1qYq7jR_Zi9Vaw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 16:08, Andrew de los Reyes wrote:
> In general, I'm positive on the change to fix the USB3 issue (yay!),
> and for the others I'm happy it's going upstream. It seem to open up
> the possibility of user-space drivers, which is great, even though we
> don't need this on our team.
> 
> One thing I want to double-check: on some devices (T651, at least),
> the raw data comes in not via HID++, but tacked onto the end of the
> normal mouse reports. Will a driver for this device be able to get all
> packets, not just HID++ ones? Sorry if this was clear and I missed it.

Yeah, that is partly why I can not send the rest of the series right
now. Nestor already warned me about those funny devices, so I need to
double check how to implement HID++.

On a technical point of view, a driver connected through the unifying
receiver currently only get the regular input reports, and this series
adds the HID++ reports to these ones. So yes, a device will receive all
reports dedicated to it.

Cheers,
Benjamin

> 
> -andrew
> 
> On Wed, Jan 8, 2014 at 2:18 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Hi Jiri,
>>
>> Well, this work is _not_ for 3.14 (except maybe patch 1), especially since it is
>> missing the biggest part where we enable the capabilities of Logitech devices.
>>
>> Long story short:
>> This work is based on the work I did back in Summer 2011. I worked at Logitech
>> for a few weeks to show up a demo of a driver for the Logitech Wireless Touchpad.
>> At that time, a first draft has been done, but due to a lack of resources, noone
>> upstreamed it.
>> Since then, the code marinated a little at Logitech and in the ChromeOS kernel
>> tree, but nobody tried to push it upstream. So here I am, trying to push this stuff
>> upstream.
>>
>> I can not send the full series right now because I am lacking most of the
>> testing hardware (I mean I only have the oldest Wireless Touchpad).
>> Hopefully, I should receive some other soon, and I'll be able to send the second
>> part then.
>>
>> Now, let me roughly explain the patches:
>> - patch 1 can be applied right now I think, but it's entirely up to you Jiri.
>>   This patch should fix the missing notifications with some USB 3.0 boards.
>> - patches 2 to 5 allows to forward in both direction the proprietary protocol
>>   used by Logitech (HID++ [1]) between the driver and the hardware.
>> - later patches will introduce a transport layer for HID++ and also a driver
>>   to support full multitouch on various Logitech touchpads.
>>
>> Nestor, Andrew, feel free to add your "Signed-off-by" whereever you want, I lost
>> a little bit the track of who added what.
>>
>> Cheers,
>> Benjamin
>>
>> [1] HID++: Documentation is provided at
>> https://drive.google.com/a/logitech.com/?tab=mo#folders/0BxbRzx7vEV7eWmgwazJ3NUFfQ28
>>
>> Benjamin Tisssoires (5):
>>   HID: logitech-dj: Fix USB 3.0 issue
>>   HID: core: do not scan reports if the group is already set
>>   HID: logitech-dj: rely on hid groups to separate receivers from dj
>>     devices
>>   HID: logitech-dj: forward incoming HID++ reports to the correct dj
>>     device
>>   HID: logitech-dj: add .request callback
>>
>>  drivers/hid/hid-core.c        |   3 +-
>>  drivers/hid/hid-logitech-dj.c | 161 +++++++++++++++++++++++++++++++++---------
>>  drivers/hid/hid-logitech-dj.h |  16 ++---
>>  include/linux/hid.h           |   1 +
>>  4 files changed, 136 insertions(+), 45 deletions(-)
>>
>> --
>> 1.8.4.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


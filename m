Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3LKA6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:58:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56071 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3LKA6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:58:37 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52A7B8B7.40600@roeck-us.net>
Date: Tue, 10 Dec 2013 16:58:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: Dave Airlie <airlied@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Radeon crash with v3.13-rc3-157-g17b2112
References: <CA+5PVA747A4283Rz-_udrFZqihgYo3_YYKw4n8Qqv5oUNQfz1w@mail.gmail.com>	<A3397C8B8B789E45844E7EC5DEAD89D030A9EC63@satlexdag05.amd.com>	<CA+5PVA432hZ4GSxTxBg4zQ9QMqKCSMK95bHbXaZ+XoPE=P_76g@mail.gmail.com> <CA+5PVA5XHcKVCngCf2gBDbPaZoWDhbh5Tk+=z_sAg-dwkcgoOw@mail.gmail.com> <A3397C8B8B789E45844E7EC5DEAD89D030A9EDE5@satlexdag05.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D030A9EDE5@satlexdag05.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 03:38 PM, Deucher, Alexander wrote:
>> -----Original Message-----
>> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of Josh
>> Boyer
>> Sent: Tuesday, December 10, 2013 6:28 PM
>> To: Deucher, Alexander
>> Cc: Guenter Roeck; Dave Airlie; Linux-Kernel@Vger. Kernel. Org; DRI mailing
>> list; Linus Torvalds
>> Subject: Re: Radeon crash with v3.13-rc3-157-g17b2112
>>
>> On Tue, Dec 10, 2013 at 5:24 PM, Josh Boyer <jwboyer@fedoraproject.org>
>> wrote:
>>> On Tue, Dec 10, 2013 at 5:07 PM, Deucher, Alexander
>>> <Alexander.Deucher@amd.com> wrote:
>>>>> -----Original Message-----
>>>>> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of
>> Josh
>>>>> Boyer
>>>>> Sent: Tuesday, December 10, 2013 5:04 PM
>>>>> To: Deucher, Alexander; Guenter Roeck; Dave Airlie
>>>>> Cc: Linux-Kernel@Vger. Kernel. Org; DRI mailing list; Linus Torvalds
>>>>> Subject: Radeon crash with v3.13-rc3-157-g17b2112
>>>>>
>>>>> Hi All,
>>>>>
>>>>> Booting today's rawhide kernel fails on my Dell XPS 8300 machine.  I
>>>>> added nomodeset to the command line because it seemed to glitch out
>>>>> when doing the handoff to the radeon driver and that let me boot far
>>>>> enough to start networking.  I then loaded the radeon driver with:
>>>>> modprobe radeon modeset=1 and was greeted with the backtrace
>> below.
>>>>>
>>>>> I haven't done a bisect yet, but I can if needs be.  I was hoping this
>>>>> would trigger someone's memory.  Plain 3.13-rc3 works, so it's
>>>>> something in the DRM merge that Linus did after -rc3.  Given the
>>>>> backtrace, this one might be suspect:
>>>>>
>>>>> commit ec39f64bba3421c2060fcbd1aeb6eec81fe0a42d
>>>>> Author: Guenter Roeck <linux@roeck-us.net>
>>>>> Date:   Fri Nov 22 21:52:00 2013 -0800
>>>>>
>>>>>      drm/radeon/dpm: Convert to use
>> devm_hwmon_register_with_groups
>>>>>
>>>>
>>>> Should be fixed by the patch in:
>>>> https://bugs.freedesktop.org/show_bug.cgi?id=72457
>>>
>>> OK.  I'll give that a spin soon.  Thanks for the quick reply!
>>
>> Yep, that seems to have fixed the crash.  I've added it to rawhide.  Thanks!
>
> It'll also be in my next -fixes pull.
>

Thanks, and sorry for the trouble.

Guenter


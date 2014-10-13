Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaJMJqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:46:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29024 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaJMJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:46:49 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b2-543b9f8655d4
Message-id: <543B9F85.9020704@samsung.com>
Date: Mon, 13 Oct 2014 11:46:45 +0200
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        irina.tirdea@intel.com
Subject: Re: [RFC PATCH 3/8] iio: core: Introduce new MOTION event
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
 <1412257439-15683-4-git-send-email-daniel.baluta@intel.com>
 <542FF252.1020206@kernel.org> <5432A474.7000700@intel.com>
 <5436E27D.8080600@kernel.org>
 <CAEnQRZAsHmYYqHAB3EeoGbTp4kHZNjfW5sx4fK=uCE_NCKaXfA@mail.gmail.com>
In-reply-to: <CAEnQRZAsHmYYqHAB3EeoGbTp4kHZNjfW5sx4fK=uCE_NCKaXfA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7pt861DDD6d1bLYuW0Vq8WzRieL
	B02rmCzmHXnHYnF51xw2B1aPxXteMnlsWtXJ5vF5k1wAcxSXTUpqTmZZapG+XQJXxrlDxxgL
	/qlXNC25zNjAuFChi5GTQ0LAROJ553FGCFtM4sK99WxdjFwcQgJLGSVW3PvLCOF8YpR4tOki
	WBWvgJbElH1/2EFsFgFViV+P34LZbALqEs07FjOD2KICERKTDt6GqheU+DH5HguILSIQIHHj
	eiNYDbNAscSpjRPA4sICThLnL0yCWraSSeLN56tgRZwCwRJbl3RDNZhJfHl5mBXClpfYvOYt
	8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHh+2UH4+JjVocY
	BTgYlXh4Lf5YhQixJpYVV+YeYpTgYFYS4T3bax0ixJuSWFmVWpQfX1Sak1p8iJGJg1OqgTHu
	rdEfg5gbO+v0Axw/za2QuvO6OnSZntqKpfJJnCnXfBjdA4/L7Fuz6zazXlnp+cjZ1xtu/C18
	e/Xp7TkFoY+LOxZyWEwQjjjzqs6muSO/oDDvkft7vjZHvYevXTv3t9kfSzK0sO9nEtX4vd/v
	juauS59OfBU/6qA/c2/1YY7Ybtnq7ze/aSmxFGckGmoxFxUnAgBshKb8PQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 11:47 AM, Daniel Baluta wrote:
> On Thu, Oct 9, 2014 at 10:31 PM, Jonathan Cameron <jic23@kernel.org> wrote:
>> On 06/10/14 15:17, Daniel Baluta wrote:
>>>
>>> On 10/04/2014 04:12 PM, Jonathan Cameron wrote:
>>>> On 02/10/14 14:43, Daniel Baluta wrote:
>>>>> This is to be used by drivers to signal detection of motion. We also
>>>>> add some possible values for motion as IIO events modifiers:
>>>>>      * running
>>>>>      * jogging
>>>>>      * walking
>>>>>      * still
>>>>>
>>>>> These values are supported by Frescale's MMA9553 sensor:
>>>>>
>>>>> http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
>>>>>
>>>>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>>>>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>>>> Hmm.. This is the interesting one.
>>>> Not immediately obvious how best to represent this stuff.
>>>>> ---
>>>>>    Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
>>>>>    drivers/iio/industrialio-core.c         | 4 ++++
>>>>>    drivers/iio/industrialio-event.c        | 1 +
>>>>>    include/linux/iio/types.h               | 7 ++++++-
>>>>>    4 files changed, 18 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>>>>> b/Documentation/ABI/testing/sysfs-bus-iio
>>>>> index d760b02..070346d 100644
>>>>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>>>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>>>>> @@ -808,6 +808,13 @@ Description:
>>>>>            number or direction is not specified, applies to all channels of
>>>>>            this type.
>>>>>
>>>>> +What:        /sys/.../events/in_activity_motion_either_en
>>>>> +KernelVersion:    3.17
>>>>> +Contact:    linux-iio@vger.kernel.org
>>>>> +Description:
>>>>> +        Enables or disables motion detection. Each time motion is detected an
>>>>> +        event of this type will be generated.
>>>>> +
>>>> The either bit seems a bit random but I can see there is no particularly obvious
>>>> alternative.
>>> I wonder if introducing a new IIO_EV_DIR_NONE event direction type would make
>>> sense. In this case the sysfs attribute will drop event direction text from its
>>> name (e.g /sys/.../events/in_activity_motion_en)
>>>
>>>> We really need a clean way of representing a multilevel 'state change' like this.
>>>>
>>>> Looking at the event code, I almost wonder if we would be better using the
>>>> direction element for running, walking etc rather than a modifier.
>>> When pushing events code to userspace the modifier seemed to be the only option.
>>>
>>>> Having said that we will probably also get devices where this is polled rather
>>>> than
>>>> event.  'What activity is currently going on?'
>>> Adding IIO_EV_INFO_VALUE bit, would create an attribute
>>> /sys/.../events/in_activity_motion_either_value that could expose the current
>>> activity going on.
>>>
>>>> If we take that view modifiers make sense as it becomes
>>>> 'Is the user running?'  Perhaps even offering a confidence interval, e.g units as
>>>> percentage
>>>> in_activity_running_input 0..100
>>>> in_activity_walking_input 0..100
>>>> etc
>>>>
>>>> Then our event becomes a state change event (yup we'll need to add that)
>>>>
>>>> /events/in_activity_walking_rising_en  will then cause events when the percentage
>>>> confidence on a state rises above the provided threshold or goes above it
>>>> (default of 50% perhaps on devices which only report one state).
>>>>
>>>> /events/in_activity_walking_falling_en will do the leaving case.
>>> This is a very nice idea and it will also offer more flexibility. I am not sure
>>> about the use case of confidence interval but using 0 and 100 will do the trick
>>> for us.
>> Sure, feel free to propose something else.  We could define a confidence interval
>> that counts as 'we think it is this'.  Basically just use values of 0 or 100 when
>> there is no explicit indication of the confidence available.  Not sure what
>> you do get ;)
>>> We will use this interface for implementation of significant motion in Android's
>>> HAL. [1]
>>>
>>> I will experiment more with how IIO attributes work and I will send a v2
>>> using direction instead of modifier for activity type (running, walking etc).
>>>
>>>
>>>> Note these are just some quick initial thoughts on alternative methods.
>>>> I'll want to think on this more and get responses from more interested
>>>> parties!
>>> Thanks a lot for your time!
>> You are welcome.  Funnily enough I rather enjoy trying to think of ways to
>> handle new 'weird' hardware in a consistent fashion :)
> We have already sent a second proposal :).
>
> http://marc.info/?l=linux-iio&m=141285801717857&w=2
>
> We are also hoping to get more opinions from other parties.
> CC'ing Karol from Samsung :).
>
> Daniel.
>
Thanks for the info.
In my case I have to figure out what is really needed between hw and 
driver first.
The existing android driver has given a data blob to user space as 
concerns new
sensor classes. Please, give a few days.

Karol

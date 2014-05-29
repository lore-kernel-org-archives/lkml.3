Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaE2WLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:11:38 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41262 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaE2WLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <5387A96C.6080404@linaro.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-3-git-send-email-bjorn.andersson@sonymobile.com>
	<53875E2A.7050902@linaro.org>
	<CAJAp7Ogd5CCsyBhQmaDsy6SAG+YPAPzEJWP0fSKHK1kov3Z6cw@mail.gmail.com>
	<5387A96C.6080404@linaro.org>
Date: Thu, 29 May 2014 15:11:35 -0700
Message-ID: <CAJAp7Ogo1uQXG5Fwa9AFEiS+K=7i+UJTQABmjPCW3ba-EYr04Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:41 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
>> Although we will not have more than one rpm in a system and therefore not
>> instatiate this driver multiple times I do not want to run it off the
>> global
>> state.
>>
> I agree.
>
> Why not make a separate data structure for the qcom_of_data?
>

That might make sense, definitely worth a spin.

>>> Should't you use the platform_get_resource_byname here?
[...]
> But my point on platform_get_resource_byname is to remove the dependency on
> the resource ordering, It is very difficult to catch errors resulting in
> wrong ordered resources in DT.
>

Sorry, forgot to answer the first part of your question.

The order in dt must be fixed, hence there isn't really any reason to
use the byname; as long as it doesn't add any context or such here. We
had a long long discussion with the dt guys about this a few months
back.

>>>> +       ret = irq_set_irq_wake(irq_ack, 1);
>>>> +       if (ret)
>>>> +               dev_warn(&pdev->dev, "failed to mark ack irq as
>>>> wakeup\n");
>>>> +
>>>
>>>
>>> ..]
>>>
>>> Shouln't these be set as part of the pm suspend call, if the device is
>>> wakeup capable?
>>>
>>>
>>
>> Is there any reason to toggle this?
>>
>> I'm not sure when this interrupt will actually be fired, but I don't see
>> any
>> harm in keeping it wakup enabled at all times.
>
>
> Typically the wake-up source is driven/enabled by the user. When the system
> goes to low-power state it would enable the wakeup on the irq. And when
> there is an interrupt it would wake up the system as part of resuming from
> low-power state.
>

But the RPM is the user; the ack irq is used to acknowledge requests
or to notify the Linux system about some event. If these happens when
the system is asleep it's always expected (in current implementation
at least) to wake up the system; hence I mark it as a wake irq.

> Again if you what this interrupt to wakeup the system, I would expect
> pm_wakeup_event/related calls in the interrupt handler too.
>

There is no power management here. I'll have to look into what value
this would add. I have to get back to you on this.

Regards,
Bjorn

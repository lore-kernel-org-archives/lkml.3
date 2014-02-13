Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaBMQQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:16:50 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58345 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaBMQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:16:49 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52FCEFEF.80707@roeck-us.net>
Date: Thu, 13 Feb 2014 08:16:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laszlo Papp <lpapp@kde.org>, Lee Jones <lee.jones@linaro.org>
CC: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a platform
 driver
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>	<20140213095817.GD32508@lee--X1>	<20140213111530.2a2b4982@endymion.delvare>	<CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>	<CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>	<20140213113313.GL32508@lee--X1> <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
In-Reply-To: <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 04:27 AM, Laszlo Papp wrote:
> On Thu, Feb 13, 2014 at 11:33 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>>>>>> -static int max6650_probe(struct i2c_client *client,
>>>>>>> -                    const struct i2c_device_id *id);
>>>>>>> -static int max6650_init_client(struct i2c_client *client);
>>>>>>> -static int max6650_remove(struct i2c_client *client);
>>>>>>> +static int max6650_probe(struct platform_device *pdev);
>>>>>>> +static int max6650_init_client(struct platform_device *pdev);
>>>>>>> +static int max6650_remove(struct platform_device *pdev);
>>>>>>>   static struct max6650_data *max6650_update_device(struct device *dev);
>>>>>>
>>>>>> It would be good to remove these forward declarations in the future.
>>>>>>
>>>>>> If no one volunteers I'll happily do it.
>>>>>
>>>>> Guenter just did:
>>>>>
>>>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
>>>>>
>>>>> Any change to the max6650 driver should go on top of his patch series
>>>>> to avoid conflicts:
>>>>>
>>>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
>>>>
>>> As far as I can see, that patch set was not even tested, so how can it
>>> go in? I was told that any patch should be _runtime_ tested, too.
>>> Fwiw, I do not have time to test those personally, he would need to
>>> find someone else if that requirement really holds true.
>>>
>>> I would not really like to fix bugs appearing in that code to get my
>>> features in.
>>>
>>> Also, since my change has been around for 2-3 months now, I would
>>> really prefer not to be forced to rewrite it again from scratch.
>>> Surely, you can wait with those, more or less, cosmetic non-runtime
>>> tested changes?
>>>
>>> This would impose me a lot of additional work again, and I personally
>>> do not see the benefit of it. In my book at least, feature is over
>>> internal polishing.
>>
>> Right, I've had enough. I'm removing your patch from the MFD tree.
>>
>> I've asked too many people to give you a second chance and asked you
>> privately to behave yourself and treat others with respect. So far I
>> haven't seen an ounce of self control or depomacy from you.
>>
>> This is how it's going to work from now on:
>>
>>   - You submit a patch
>>   - It gets reviewed                            <----\
>>   - You fix up the review comments as requested -----/
>>   - Non-compliance or arguments with the _experts_ results in:
>>      `$INTEREST > /dev/null || \
>>        grep "From: Laszio Papp" ~/.mail | xargs rm -rf`
>
> http://comments.gmane.org/gmane.linux.kernel/1645251
>
> Step 2 did not happen. I did not get any review for my change. I
> literally submitted that within a couple of hours after the request.
>

If you had tested your patch on real or simulated hardware,
you might have noticed a crash whenever you accessed any
of the attributes. So you did not test your patch.

Instead of trying to educate you how the conversion to the
new API works, I decided to help you out a bit and do
the conversion myself. I did some cleanup before, since
that made the actual feature patch easier for me to implement,
and I did some more cleanup afterwards just because I like
cleaning up code.

I had hoped that you might find the time to test the result,
but it appears that won't happen. I am gracious to Jean that
he took the time to review the changes and even test the
result in simulation, even though I know he is very busy.
So I consider the changes to be good enough to be made
available in my -staging tree, which I did by now.
I'll move them over to -next once I have the chance to test
on real hardware or after I get a Tested-by: from someone
with real hardware.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaBMM1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:27:30 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46793 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaBMM13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:27:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140213113313.GL32508@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	<20140213095817.GD32508@lee--X1>
	<20140213111530.2a2b4982@endymion.delvare>
	<CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
	<CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
	<20140213113313.GL32508@lee--X1>
Date: Thu, 13 Feb 2014 12:27:28 +0000
X-Google-Sender-Auth: LkWbhk2WqUwe--e0eDdreqTI1tM
Message-ID: <CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:33 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >>> > -static int max6650_probe(struct i2c_client *client,
>> >>> > -                    const struct i2c_device_id *id);
>> >>> > -static int max6650_init_client(struct i2c_client *client);
>> >>> > -static int max6650_remove(struct i2c_client *client);
>> >>> > +static int max6650_probe(struct platform_device *pdev);
>> >>> > +static int max6650_init_client(struct platform_device *pdev);
>> >>> > +static int max6650_remove(struct platform_device *pdev);
>> >>> >  static struct max6650_data *max6650_update_device(struct device *dev);
>> >>>
>> >>> It would be good to remove these forward declarations in the future.
>> >>>
>> >>> If no one volunteers I'll happily do it.
>> >>
>> >> Guenter just did:
>> >>
>> >> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
>> >>
>> >> Any change to the max6650 driver should go on top of his patch series
>> >> to avoid conflicts:
>> >>
>> >> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
>> >
>> As far as I can see, that patch set was not even tested, so how can it
>> go in? I was told that any patch should be _runtime_ tested, too.
>> Fwiw, I do not have time to test those personally, he would need to
>> find someone else if that requirement really holds true.
>>
>> I would not really like to fix bugs appearing in that code to get my
>> features in.
>>
>> Also, since my change has been around for 2-3 months now, I would
>> really prefer not to be forced to rewrite it again from scratch.
>> Surely, you can wait with those, more or less, cosmetic non-runtime
>> tested changes?
>>
>> This would impose me a lot of additional work again, and I personally
>> do not see the benefit of it. In my book at least, feature is over
>> internal polishing.
>
> Right, I've had enough. I'm removing your patch from the MFD tree.
>
> I've asked too many people to give you a second chance and asked you
> privately to behave yourself and treat others with respect. So far I
> haven't seen an ounce of self control or depomacy from you.
>
> This is how it's going to work from now on:
>
>  - You submit a patch
>  - It gets reviewed                            <----\
>  - You fix up the review comments as requested -----/
>  - Non-compliance or arguments with the _experts_ results in:
>     `$INTEREST > /dev/null || \
>       grep "From: Laszio Papp" ~/.mail | xargs rm -rf`

http://comments.gmane.org/gmane.linux.kernel/1645251

Step 2 did not happen. I did not get any review for my change. I
literally submitted that within a couple of hours after the request.

Could you please tell me what was wrong with that change, and why I
did not get any respect not to "xargs rm -rf" my work in that area? I
believe I was ignored instead of improving the change, and someone
else tried to address the same thing. There was no argument in that
thread. It was a technical change. I personally do not feel happy
about it.

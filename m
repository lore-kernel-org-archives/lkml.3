Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3KVOfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:35:41 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52907 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3KVOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:35:39 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528F6BB8.8040504@roeck-us.net>
Date: Fri, 22 Nov 2013 06:35:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laszlo Papp <lpapp@kde.org>
CC: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
References: <20131114181845.GA13727@roeck-us.net>	<CAOMwXhNaZ=oqp5mjnCrOSkdax5U6ffsZf_p4mzd3W2jF+=xWqg@mail.gmail.com>	<20131114190044.GE13727@roeck-us.net>	<CAOMwXhPvPnprrJx-1dfJnO+E12sxAE9M_sYg7tyzp4dsDa8vyg@mail.gmail.com>	<CAJ4dqQu0=HP=Ut+VnNjkSL2cE8QN+JRa-Xd8X01ij+ijKUKxwA@mail.gmail.com>	<CAOMwXhM1Xi=UqpmKNDsOnQLXKo1o+65TZi6AkBk4Ds9wuXSaWQ@mail.gmail.com>	<20131119165438.GD30481@roeck-us.net>	<20131119180007.GB16693@roeck-us.net>	<CAOMwXhOTRVu1EMSNE_muKKfSYBFQ1XVq1EQEL2d+wCwRJ0tkpw@mail.gmail.com>	<CAOMwXhN8tZej9=65wyGvsnm64igiLLN6vdsiGaePCozKBs8J7Q@mail.gmail.com>	<20131121173458.GC10783@roeck-us.net>	<CAOMwXhNzpsiiK5NzxoXM56ACGmHo1gpm3OT6=kw29XQDFmyPAA@mail.gmail.com> <CAOMwXhPUR02fQ1EhV6K9eQW02kNHn55dTEND+R59g1=zC5qDWQ@mail.gmail.com>
In-Reply-To: <CAOMwXhPUR02fQ1EhV6K9eQW02kNHn55dTEND+R59g1=zC5qDWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 01:23 AM, Laszlo Papp wrote:
> Just to clarify: you want to have ./gpio/gpio-max6650.c?
>
No, I never said that. I wanted you to register the gpio pins
with the gpio subsystem. I didn't ask you to write a separate
driver for it.

Sure, strictly speaking one could write a top level mfd driver
and separate gpio and hwmon drivers, but at least in my opinion
that would be overkill. I also never suggested this; you brought
the term mfd into the discussion.

Guenter

> On Thu, Nov 21, 2013 at 8:52 PM, Laszlo Papp <lpapp@kde.org> wrote:
>> On Thu, Nov 21, 2013 at 5:34 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> On Thu, Nov 21, 2013 at 03:20:34PM +0000, Laszlo Papp wrote:
>>>> One week passed since the initial submit. Any feedback from the
>>>> maintainer who accepts patches for this?
>>>>
>>> Last time I checked that was either Jean Delvare or me.
>>>
>>> As I already told you, I won't accept the patch as-is,
>>> and I told you what would need to be changed to have it accepted.
>>>
>>> In general, we don't support adding non-standard sysfs attributes in hwmon
>>> drivers unless really needed and discussed. As I see it, there is no need
>>> for non-standard sysfs attributes in this driver; you _could_ use
>>> the gpio subsystem. You chose not to and provide non-standard sysfs
>>> attributes instead, essentially duplicating gpio subsystem functionality.
>>
>> MFD != gpio subsystem, but for some reason or another you continuously
>> overlook that. You also disregard what Markus wrote: this change is
>> just following the existing convention in there. Basically, your
>> suggestion would lead to a mixed interface where some feature of the
>> chip is exposed in 3-4 other places, and some centrally and in a
>> compact manner in hwmon.
>>
>>> I see it as even more important to use the gpio subsystem for the intended use
>>> case, which is to use gpio pins for fan control. In that case, providing access
>>> through the gpio subsystem would enable using the gpio-fan driver to actually
>>> control the fans.
>>
>> That is clearly incorrect. To write a proper userspace middleware
>> would imply fishing stuff from several subspaces rather than using the
>> same compact interface. I called that a nightmare from end user point
>> of view.
>>
>>> You may consider that to be personal taste nitpicking. I don't.
>>
>> I consider it worse than nitpicking eventually: imho, it is rejecting
>> a validated feature without providing a better change. It is a shame,
>> but we cannot do anything more at this point to provide remedy here
>> without getting financial loss, further time spent on a full rewrite,
>> and relevant study, etc. The kernel will remain without this feature
>> probably. I see it as a loss/loss for both parties. You will save
>> maintaining it (even though it is me who would probably need to
>> maintain this feature for the next few years...) for the cost of not
>> having the feature at all, most likely.
>>
>> Well, I guess we will need to stick to a more feature-rich forked
>> version for us then.
>
>


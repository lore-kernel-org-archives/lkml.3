Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaEQWTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:19:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54156 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaEQWTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:19:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5377E04E.2070505@roeck-us.net>
Date: Sat, 17 May 2014 15:18:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
References: <201405162037.41782@pali>	<20140516211117.0c766287@endymion.delvare>	<53777F72.3000907@roeck-us.net> <20140517230940.25c36f07@endymion.delvare>
In-Reply-To: <20140517230940.25c36f07@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 02:09 PM, Jean Delvare wrote:
> On Sat, 17 May 2014 08:25:38 -0700, Guenter Roeck wrote:
>> On 05/16/2014 12:11 PM, Jean Delvare wrote:
>>> Load the i8k driver with fan_mult=1.
>>
>> Would it make sense to change the default multiplier to 1 ?
>> Lots of people have problems with it, and trying to figure out
>> affected machines one by one would be an all but impossible task.
>
> That would cause a regression on many (presumably older) machines. I
> doubt this is acceptable. One option would be to use the ACPI year to
> change the default, if indeed all new machines need fan_mult=1. I don't
> know if this is the case.
>
> One this I had in mind was auto-detecting the scaling factor. AFAIK
> only 30 and 1 are possible values, so any value above ~300 would imply
> scaling factor of 1 (30 would make it > 9000 RPM which is unrealistic.)
> But I don't know if we can actually do that, as such a simple heuristic
> could easily fail is the fan is stopped (30 * 0 == 1 * 0) or if the
> returned raw speed is temporarily unreliable for whatever reason.
>
Sounds like an idea. We could make the cutoff higher, such as 500 or
even 1000. I am not much concerned about 0 rpm - the code could simply check
the returned rpm and adjust the scaling factor to 1 if the reading is too
high. Since 30*0 is still 0, there is no problem if the fan is stopped.

> I have to admit that working on a reverse engineered driver for
> hardware I don't even have isn't quite at the top of my to-do list.
>

;-). We have several of those systems, so there is at least some interest
on my side. If I have time, I'll play around with it. The driver does need
major cleanup, though, so that may take a while.

Guenter


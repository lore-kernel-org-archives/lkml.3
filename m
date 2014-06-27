Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaF0Iur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:50:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53673 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaF0Ium (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:50:42 -0400
Message-ID: <53AD2F99.1010004@ahsoftware.de>
Date: Fri, 27 Jun 2014 10:47:21 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: John Whitmore <arigead@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: rtc/hctosys.c Problem during kernel boot
References: <20140611230127.GA28066@griso.site>	<CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>	<53A583DC.504@ahsoftware.de> <CALAqxLUYbp9qXpFusw=Nteqht33Lz9ch5g6Ptv1cMoFEgC+M9Q@mail.gmail.com>
In-Reply-To: <CALAqxLUYbp9qXpFusw=Nteqht33Lz9ch5g6Ptv1cMoFEgC+M9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.06.2014 23:36, schrieb John Stultz:
> On Sat, Jun 21, 2014 at 6:08 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 12.06.2014 01:53, schrieb John Stultz:
>>
>>> You can read some of the previous discussion here:
>>> https://lkml.org/lkml/2013/6/17/533
>>>
>>> I'd be very interested in patches to resolve this!
>>
>>
>> And the silence as response to my repost of my already working patches just
>> proved that isn't true.
>
> You put in your patches the following:
> "Besides discussing possible *real* bugs, I don't care what any person
>   (including maintainers) will request. I'm fine with these patches (I'm
>   using them since a year) and I don't play remote keyboard or
>   patch ping-pong. If someone want changes I suggest he gets responsible
>   for them himself and just puts a patch on top of my patches. And in any
>   case, feel free to completely ignore these patches."
>
> I've pointed out problems with your patchset earlier, and you refuse
> to address them. That's totally your prerogative, and that's fine, but
> I don't know how I should respond here.

I've written that because I will not add a totally unnecessary lock in a 
code path which does set the system time. If multiple RTCs do race to 
set the system time, the system was configured wrong and is already 
untrustworthy and a lock inside the kernel won't help. Especially 
because it will not remove the race, and just solve it somehow. And 
that's happen without a lock (which might block or even dead lock if 
done wrong) too.

So if you want a lock there, please add such a patch yourself and be 
responsible for it. I will not do such.

> I agree that there is an issue here that your patches try to address,
> which needs to be fixed, but I'm hoping John Whitmore might be able to
> read the discussion and either rework your patches or write his own to
> address the issue without the problems in your patch I pointed out.
>
> I've removed the rest of your anti-maintainer rant here, but I will
> say that I do very much understand that the upstream kernel community
> process can be frustrating at times. I have myself had to start over
> many many times on patches when maintainers request, and sometimes my
> patches don't ever make it past the bar for acceptance. So I very much
> do see this from both sides, and despite my frustration, I appreciate
> that folks are looking over my patches carefully for design and
> maintenance issues, because without the high standards, the kernel
> code would be in much worse shape.

Unfortunately I really think you believe what you are writing.

But my experience is that even totally silly and very small bugfixes 
like oneliners are discussed to death and do need years to end up in a 
mainline kernel, if they end up there at all.

And it doesn't help if maintainers do request silly things. My 
experience here is that they always will request a change, even for 
perfect patches, just to request something. If a patch contains a 
variable named red, they would request to change it to green and if it 
would have a name green, they would request to change it to red.

So I'm sorry, but in my humble opinion that isn't how a high standard 
does look like. Many request from maintainer are just capriciousness or 
despotism and often maintainers are totally wrong. And discussing with 
them just leads to ignored patches/bugfixes.

Regards,

Alexander Holler


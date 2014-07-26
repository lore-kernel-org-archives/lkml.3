Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaGZQ6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:58:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58073 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaGZQ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:58:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D3DE22.1010305@roeck-us.net>
Date: Sat, 26 Jul 2014 09:58:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Nick Krause <xerofoify@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>	<53CFC170.9090505@roeck-us.net> <CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
In-Reply-To: <CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 08:21 AM, Geert Uytterhoeven wrote:
> On Wed, Jul 23, 2014 at 4:06 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 07/23/2014 05:51 AM, Sasha Levin wrote:
>>> Revert since we're trying to return -ENXIO from a function returning
>>> unsigned int. Not only it causes compiler warnings it's also obviously
>>> incorrect.
>>>
>>> In general, watch for patches from Nick Krause since they are not even
>>> build tested.
>>>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>>
>> Guess I wasn't fast enough with my comments :-(
>>
>> Acked-by: Guenter Roeck <linux@roeck-us.net>
>
> I applied Nick's cleanup (which is not yet in mainline, just in the m68k repo)
> because I thought Nick was right (in this particular case ;-), cfr. my
> reasoning in www.spinics.net/lists/kernel/msg1774736.html
>
> W.r.t. the signess, I didn't see the compiler warning, as the version of gcc
> I'm using didn't print that warning. However, irq_startup() converts the
> value returned by .irq_startup() from unsigned to signed.
> I assume this is just a missing conversion when the genirq framework
> itself was introduced (m68k was converted quite late)?
>
> W.r.t. the actual value, any non-zero value is treated the same.
> I can change it to 1, if that makes you feel better. If returning a non-zero
> value here is wrong, presumable the code has been wrong since it
> incarnation.
>
In my understanding, anything not equal to 0 means that an interrupt
is pending, not that there was an error. Maybe my understanding is wrong.

Either case, I don't really care.

Guenter


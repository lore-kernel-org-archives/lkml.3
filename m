Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaFNVVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:21:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:51128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbaFNVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:21:35 -0400
Message-ID: <539CBD51.8090409@kernel.org>
Date: Sat, 14 Jun 2014 22:23:29 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Himangi Saraogi <himangi774@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] iio: adc: at91_adc: Correct call to input_free_device
References: <20140613171146.GA2831@himangi-Dell> <539C6D20.7080907@kernel.org> <20140614211727.GA3137@piout.net>
In-Reply-To: <20140614211727.GA3137@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/14 22:17, Alexandre Belloni wrote:
> On 14/06/2014 at 16:41:20 +0100, Jonathan Cameron wrote :
>> On 13/06/14 18:11, Himangi Saraogi wrote:
>>> This error handling code can be reached before st->ts_input is
>>> initialized, so it is safer to always use the original name, input_dev.
>>>
>>> A simplified version of the semantic match that finds this problem is:
>>>
>>> // <smpl>
>>> @r exists@
>>> local idexpression struct input_dev * x;
>>> expression ra,rr;
>>> @@
>>>
>>> * x = input_allocate_device(...)
>>> ...  when != x = rr
>>>       when != input_free_device(x,...)
>>>       when != if (...) { ... input_free_device(x,...) ...}
>>> if(...) { ... when != x = ra
>>>       when forall
>>> *     when != input_free_device(x,...)
>>>   \(return <+...x...+>; \| return...; \) }
>>>
>>> // </smpl>
>>>
>>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>> The error handling in this function has been completely rewritten so the
>> bug is no longer there and this no longer applies.
>
> Hum, actually, you are wrong and I introduced that bug in 3.16. The
> change didn't come from your tree so it is not up to date.
>
> So either you take it after 3.16-rc1 or we can ask Nicolas to get it
> through the at91 tree.
Ah, that would do it!
I'm lagging a bit (just sending a pull request for some fixes from pre 3.16
merge window opening).  Will pick this up later in the week.

oops.

J
>
>
> Either way:
>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>


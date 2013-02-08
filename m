Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023Ab3BHGzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:55:18 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:47319 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3BHGzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:55:15 -0500
Message-ID: <5114A150.5040508@250bpm.com>
Date: Fri, 08 Feb 2013 07:55:12 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <5113FCA7.4020207@mit.edu> <51140A60.4070705@250bpm.com> <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com> <51148C93.6020204@250bpm.com> <CALCETrVjRg95+xDnsg0L6JMYeFjFTr3HST9Mmi9utxrF1PggNQ@mail.gmail.com>
In-Reply-To: <CALCETrVjRg95+xDnsg0L6JMYeFjFTr3HST9Mmi9utxrF1PggNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/13 07:36, Andy Lutomirski wrote:

>> On 08/02/13 02:03, Andy Lutomirski wrote:
>>>
>>> There may be some
>>> advantage to adding (later on, if needed) an option to change the
>>> flags set in:
>>>
>>> +               if (waitqueue_active(&ctx->wqh))
>>> +                       wake_up_locked_poll(&ctx->wqh,
>>> +                               (unsigned long)ctx->mask.events);
>>>
>>> (i.e. to allow the second parameter to omit some bits that were
>>> already signaled.)  Allowing write to write a bigger struct in the
>>> future won't break anything.
>>
>>
>> I think I don't follow. Either the second parameter is supposed to be
>> *newly* signaled events, in which case the events that were already signaled
>> in the past should be ommitted, or it is meant to be *all* signaled events,
>> in which case the current implementation is OK.
>
> I defer to the experts here.  But I suspect that if you want to
> perfectly emulate sockets, you may need to vary what you specify.
> (IIRC tcp sockets report an EPOLLIN edge every time data is received
> even if the receive buffer wasn't empty.)

Hm. That sounds like leaking protocol implementation details to the 
user. That's a bad design IMO and should not be encouraged.

Anyway, I have implemented your other suggestions.

Btw, one thing I am not sure about is how to submit improved patches to 
the ML. Should I use the same patch name? Doesn't that cause confusion?

Martin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab3BSWqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:46:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49663 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3BSWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:46:13 -0500
Message-ID: <512400B2.9010801@mit.edu>
Date: Tue, 19 Feb 2013 14:46:10 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>
Subject: Re: [resend] Timer broadcast question
References: <5123BE35.8070902@linaro.org> <alpine.LFD.2.02.1302191904560.22263@ionos> <5123C299.3080005@linaro.org>
In-Reply-To: <5123C299.3080005@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 10:21 AM, Daniel Lezcano wrote:
> On 02/19/2013 07:10 PM, Thomas Gleixner wrote:
>> On Tue, 19 Feb 2013, Daniel Lezcano wrote:
>>> I am working on identifying the different wakeup sources from the
>>> interrupts and I have a question regarding the timer broadcast.
>>>
>>> The broadcast timer is setup to the next event and that will wake up any
>>> idle cpu belonging to the "broadcast cpumask", right ?
>>>
>>> The cpu which has been woken up will look for each cpu the next-event
>>> and send an IPI to wake it up.
>>>  
>>> Although, it is possible the sender of this IPI may not be concerned by
>>> the timer expiration and has been woken up just for sending the IPI, right ?
>>
>> Correct.
>>  
>>> If this is correct, is it possible to setup the timer irq affinity to a
>>> cpu which will be concerned by the timer expiration ? so we prevent an
>>> unnecessary wake up for a cpu.
>>
>> It is possible, but we never implemented it.
>>
>> If we go there, we want to make that conditional on a property flag,
>> because some interrupt controllers especially on x86 only allow to
>> move the affinity from interrupt context, which is pointless.
> 
> Thanks Thomas for your quick answer. I will write a RFC patchset.

I'm curious what the use case is.  I played with this code awhile ago,
and AFAICT it's not used on sensible (i.e. modern) systems.  Is there
anything other than old x86 machines that needs it?

--Andy

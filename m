Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3BSSVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:21:18 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:38028 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3BSSVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:21:17 -0500
Message-ID: <5123C299.3080005@linaro.org>
Date: Tue, 19 Feb 2013 19:21:13 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>
Subject: Re: [resend] Timer broadcast question
References: <5123BE35.8070902@linaro.org> <alpine.LFD.2.02.1302191904560.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302191904560.22263@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 07:10 PM, Thomas Gleixner wrote:
> On Tue, 19 Feb 2013, Daniel Lezcano wrote:
>> I am working on identifying the different wakeup sources from the
>> interrupts and I have a question regarding the timer broadcast.
>>
>> The broadcast timer is setup to the next event and that will wake up any
>> idle cpu belonging to the "broadcast cpumask", right ?
>>
>> The cpu which has been woken up will look for each cpu the next-event
>> and send an IPI to wake it up.
>>  
>> Although, it is possible the sender of this IPI may not be concerned by
>> the timer expiration and has been woken up just for sending the IPI, right ?
> 
> Correct.
>  
>> If this is correct, is it possible to setup the timer irq affinity to a
>> cpu which will be concerned by the timer expiration ? so we prevent an
>> unnecessary wake up for a cpu.
> 
> It is possible, but we never implemented it.
> 
> If we go there, we want to make that conditional on a property flag,
> because some interrupt controllers especially on x86 only allow to
> move the affinity from interrupt context, which is pointless.

Thanks Thomas for your quick answer. I will write a RFC patchset.

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


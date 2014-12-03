Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLCOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:53:46 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35001 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaLCOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:53:45 -0500
Message-ID: <547F23F0.7030507@linaro.org>
Date: Wed, 03 Dec 2014 14:53:36 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Sander <tim@krieglstein.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <5910085.Y47hdorDAO@dabox> <547C77A0.8030208@linaro.org> <4591842.obBcGFvQjh@dabox>
In-Reply-To: <4591842.obBcGFvQjh@dabox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 13:41, Tim Sander wrote:
>>> Even with using the FIQ on a Linux SMP system you have not heard from me
>>> before, as i knew that this is not your problem (and that is not to say
>>> that there where none!). The only interface Linux has been making
>>> available is set_fiq_handler. So it was clear that the FIQ is its own
>>> domain otherwise untouched by the kernel. Now the line gets blurried with
>>> the linux kernel moving to use the FIQ. And with the descicions
>>> forthcoming its not only grabbing land it also claims a previous public
>>> path for its own. So it doesn't help that its planting some flowers along
>>> the way. So please be nice to the natural inhabitants...
>>
>> Surely only upstream code could claim to be a natural inhabitant.
> Well from a kernel developer perspective this might be true, but well there 
> are things, e.g. the stuff the nice guys at free electrons did, which are quite
> reasonable but would be laughed at if tried to include in the kernel:
> http://free-electrons.com/blog/fiq-handlers-in-the-arm-linux-kernel/
> Still this shows very much that you can build quite powerfull systems which 
> combine both the power of linux with the lowes latency the bare hardware can 
> give you.
> 
>> Whenever I've been working on code that, for whatever reason, cannot be
>> upstreamed I'd probably best be regarded as a tourist.
> I think that application specific code which needs all the power the hardware 
> gives you in a given power envelope and is so optimized for a special usecase 
> that integration in kernel makes no sense. So i would hope for a more 
> constructive mindset.

A bad choice of words on my part (although in truth it remains an
accurate description of my own experience of working on code not
destined to be upstreamed).

However I certainly want to be constructive.

>>> And i really don't get it, that neither ARM nor the kernel community sees
>>> fast interrupts as a worthwhile usecase. Unfortunatly the interrupt
>>> latencies with Linux are at least a order of magnitude higher than the
>>> pure hardware even with longer pipelines can deliver.
>>>
>>>> Therefore, as far as I'm concerned, the two facilities are mututally
>>>> exclusive.
>>>
>>> Well can't have the cake and eat it too.
>>>
>>>> I had thought about whether the IPI FIQ should be disabled when a
>>>> replacement FIQ handler is installed, I deem it not to be a use case
>>>> that the mainline kernel needs to be concerned about.
>>>
>>> That would be nice.
>>
>> Just to be clear, this is exactly the dynamic switching that I mentioned
>> a couple of mails ago.
> Ok, my takeaway is there is currently not enough interest from your side to 
> implement it but you would support some changes if submitted?

I'd take a good look at them (assuming I'm on Cc: or my mail filters
pick them out). I may still have some concerns about testing it in the
absence of an upstream user but otherwise I would expect to be supportive.

>> As I said such code should not especially hard to write but, with the
>> current mainline kernel, the code would be unreachable and, as a result,
>> likely also to be more or less untested.
> Well, my misconception was, that this might be done by adding some ifdefs
> but as Russell pointed out, that is not the way to go.

Whether its dynamic or not, a change that does not provide some benefit
to the upstream kernel is always going to be much harder to sell to the
people who have to maintain it because they derive much benefit from
maintaining it.


Daniel.

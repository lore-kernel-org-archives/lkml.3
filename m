Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaIMMBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 08:01:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62982 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaIMMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 08:01:23 -0400
Message-ID: <54143210.1070704@linaro.org>
Date: Sat, 13 Sep 2014 13:01:20 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org> <20140912170307.GL12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140912170307.GL12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 18:03, Russell King - ARM Linux wrote:
> On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
>> -	.macro	svc_entry, stack_hole=0
>> +	.macro	svc_entry, stack_hole=0, call_trace=1
>>   UNWIND(.fnstart		)
>>   UNWIND(.save {r0 - pc}		)
>>  	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
>> @@ -183,7 +183,9 @@ ENDPROC(__und_invalid)
>>  	stmia	r7, {r2 - r6}
>>  
>>  #ifdef CONFIG_TRACE_IRQFLAGS
>> +	.if \call_trace
>>  	bl	trace_hardirqs_off
>> +	.endif
>>  #endif
> 
> Good, you picked this up from my patch.  But what about the call into
> lockdep from usr_entry?

That was writen from your review comment rather than taken from your patch.

> Yes, it should be safe if we're entering from user mode, because by
> definition, the kernel can't be holding any locks at that point.
> However, I'd much prefer to keep to a set of simple rules here: avoid
> lockdep in FIQ code altogether.

Ok. You're right that I followed the "can't be holding any locks" logic
when I didn't update usr_entry in reaction to the original review comment.

I'm also happy with the "avoid lockdep in FIQ code altogether" approach.
I'll do this.

> That's much easier to understand than "we can call into lockdep provided
> we've been entered from user mode".
> 
> The other thing you miss is that /potentially/ call into the scheduler
> as well from a FIQ.  Do we /really/ want to do that kind of work here?
> 
> Not happy.

Sorry. I will fix these.


Daniel.



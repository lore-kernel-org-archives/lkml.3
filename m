Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaJKQ35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:29:57 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45604 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJKQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:29:56 -0400
Message-ID: <54395B00.4070208@martingkelly.com>
Date: Sat, 11 Oct 2014 09:29:52 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: x86@kernel.org
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] context_tracking: Fix checkpatch warnings
References: <1410841232-24591-1-git-send-email-martin@martingkelly.com> <CAN8CM3zXEL8UFRcJqVN9rq-AY1Mk1_xL0eNdRHZEYRgL8ouh9Q@mail.gmail.com>
In-Reply-To: <CAN8CM3zXEL8UFRcJqVN9rq-AY1Mk1_xL0eNdRHZEYRgL8ouh9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 09:25 AM, Martin Kelly wrote:
> On Mon, Sep 15, 2014 at 9:20 PM, Martin Kelly <martin@martingkelly.com> wrote:
>> checkpatch emits several warnings for context_tracking.c, which are
>> fixed in this patch:
>>
>> - No space after "("
>> - Lines longer than 80 characters
>>
>> Signed-off-by: Martin Kelly <martkell@amazon.com>
>> ---
>>  kernel/context_tracking.c | 40 +++++++++++++++++++++-------------------
>>  1 file changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>> index 5664985..bf29065 100644
>> --- a/kernel/context_tracking.c
>> +++ b/kernel/context_tracking.c
>> @@ -54,8 +54,8 @@ void context_tracking_user_enter(void)
>>         /*
>>          * Repeat the user_enter() check here because some archs may be calling
>>          * this from asm and if no CPU needs context tracking, they shouldn't
>> -        * go further. Repeat the check here until they support the inline static
>> -        * key check.
>> +        * go further. Repeat the check here until they support the inline
>> +        * static key check.
>>          */
>>         if (!context_tracking_is_enabled())
>>                 return;
>> @@ -75,31 +75,33 @@ void context_tracking_user_enter(void)
>>         WARN_ON_ONCE(!current->mm);
>>
>>         local_irq_save(flags);
>> -       if ( __this_cpu_read(context_tracking.state) != IN_USER) {
>> +       if (__this_cpu_read(context_tracking.state) != IN_USER) {
>>                 if (__this_cpu_read(context_tracking.active)) {
>>                         trace_user_enter(0);
>>                         /*
>> -                        * At this stage, only low level arch entry code remains and
>> -                        * then we'll run in userspace. We can assume there won't be
>> -                        * any RCU read-side critical section until the next call to
>> -                        * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
>> -                        * on the tick.
>> +                        * At this stage, only low level arch entry code
>> +                        * remains and then we'll run in userspace. We can
>> +                        * assume there won't be any RCU read-side critical
>> +                        * section until the next call to user_exit() or
>> +                        * rcu_irq_enter(). Let's remove RCU's dependency on
>> +                        * the tick.
>>                          */
>>                         vtime_user_enter(current);
>>                         rcu_user_enter();
>>                 }
>>                 /*
>> -                * Even if context tracking is disabled on this CPU, because it's outside
>> -                * the full dynticks mask for example, we still have to keep track of the
>> -                * context transitions and states to prevent inconsistency on those of
>> -                * other CPUs.
>> -                * If a task triggers an exception in userspace, sleep on the exception
>> -                * handler and then migrate to another CPU, that new CPU must know where
>> -                * the exception returns by the time we call exception_exit().
>> -                * This information can only be provided by the previous CPU when it called
>> -                * exception_enter().
>> -                * OTOH we can spare the calls to vtime and RCU when context_tracking.active
>> -                * is false because we know that CPU is not tickless.
>> +                * Even if context tracking is disabled on this CPU, because
>> +                * it's outside the full dynticks mask for example, we still
>> +                * have to keep track of the context transitions and states to
>> +                * prevent inconsistency on those of other CPUs.  If a task
>> +                * triggers an exception in userspace, sleep on the exception
>> +                * handler and then migrate to another CPU, that new CPU must
>> +                * know where the exception returns by the time we call
>> +                * exception_exit().  This information can only be provided by
>> +                * the previous CPU when it called exception_enter().  OTOH we
>> +                * can spare the calls to vtime and RCU when
>> +                * context_tracking.active is false because we know that CPU is
>> +                * not tickless.
>>                  */
>>                 __this_cpu_write(context_tracking.state, IN_USER);
>>         }
>> --
>> 2.1.0
>>
> 
> (ping)
> 

(re-ping)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaJ1Bx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:53:58 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:42645 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJ1Bx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1410221630120.6969@knanqh.ubzr>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
	<1413822343-1972-2-git-send-email-daniel.lezcano@linaro.org>
	<alpine.LFD.2.11.1410221630120.6969@knanqh.ubzr>
Date: Mon, 27 Oct 2014 21:53:56 -0400
X-Google-Sender-Auth: 4P1y1yKf2w_fzVMoZcr4ruzO9wo
Message-ID: <CAJvTdKmww7mONuRSxF6v9gWLXXbHYqrA2QZVTjSP0iwH3n+KnA@mail.gmail.com>
Subject: Re: [PATCH 2/5] sched: idle: Get the next timer event and pass it the
 cpuidle framework
From: Len Brown <lenb@kernel.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Len Brown <len.brown@intel.com>

On Wed, Oct 22, 2014 at 4:38 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Mon, 20 Oct 2014, Daniel Lezcano wrote:
>
>> Following the logic of the previous patch, retrieve from the idle task the
>> expected timer sleep duration and pass it to the cpuidle framework.
>>
>> Take the opportunity to remove the unused headers in the menu.c file.
>>
>> This patch does not change the current behavior.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> One minor nit below.
>
>> @@ -211,6 +212,12 @@ static void cpu_idle_loop(void)
>>                       latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>>
>>                       /*
>> +                      * The next timer event in us
>> +                      */
>
> This 3-line comment is redundant. The code is obvious enough on its own.
>
>> +                     next_timer_event = ktime_to_us(
>> +                             tick_nohz_get_sleep_length());
>
> I'd suggest this form for better readability:
>
>                         next_timer_event =
>                                 ktime_to_us(tick_nohz_get_sleep_length());
>
> Other than that...
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
>
>> +
>> +                     /*
>>                        * In poll mode we reenable interrupts and spin.
>>                        *
>>                        * If the latency req is zero, we don't want to
>> @@ -227,7 +234,8 @@ static void cpu_idle_loop(void)
>>                           tick_check_broadcast_expired())
>>                               cpu_idle_poll();
>>                       else
>> -                             cpuidle_idle_call(latency_req);
>> +                             cpuidle_idle_call(latency_req,
>> +                                               next_timer_event);
>>
>>                       arch_cpu_idle_exit();
>>               }
>> --
>> 1.9.1
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Len Brown, Intel Open Source Technology Center

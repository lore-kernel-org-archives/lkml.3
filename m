Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaDIKtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:49:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44390 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDIKto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
Date: Wed, 9 Apr 2014 16:19:44 +0530
Message-ID: <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 16:03, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Frederic,
>
> File: kernel/time/tick-sched.c
> Function: tick_nohz_full_stop_tick()
>
> We are doing this:
>
> if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
>         return;
>
> Which means: if a FULL_NO_HZ cpu is running idle task currently,
> don't stop its tick..
>
> I couldn't understand why. Can you please help here?

Is it because of this code ? :

void tick_nohz_irq_exit(void)
{
        struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);

        if (ts->inidle)
                __tick_nohz_idle_enter(ts);
        else
                tick_nohz_full_stop_tick(ts);
}

i.e. tick_nohz_full_stop_tick() would never be called while we have
'inidle' set or we are running idle task?

In this case as well, we don't really need that check to be present.

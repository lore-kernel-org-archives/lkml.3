Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaAGPCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:02:03 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36036 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaAGPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=4NDhfmBtt5N+WShZS-=QwWcaFu6OmH-ERgHcAEcrFPQ@mail.gmail.com>
References: <CAKohpo=4NDhfmBtt5N+WShZS-=QwWcaFu6OmH-ERgHcAEcrFPQ@mail.gmail.com>
Date: Tue, 7 Jan 2014 20:31:52 +0530
Message-ID: <CAKohpokQ52nrO9JrQhohsH78=mbJyaC4eBK4DwvO1Azfz9vEGg@mail.gmail.com>
Subject: Re: [Query]: Timer overflow events on core isolated with NO_HZ_FULL
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed lists earlier :(

On 7 January 2014 20:31, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Kevin/Frederic,
>
> In my traces I see a guaranteed interrupt on the isolated
> core, which is running under NO_HZ_FULL mode and is
> running a single thread "stress", after ~90 seconds.
>
> When I look into the traces I see we get only two events:
> - irq-handler-entry
> - irq-handler-exit
>
> And no more detail is available in the traces, system again
> goes to no interruption mode for next 90 seconds.
>
> I hope this is because the timers we have queued for long
> enough times are getting overflowed? I tried to enable
> cpusets and then see which timers are active on CPU1 from
> /proc/timer_list and that gave me:
>
> tick_sched_timer and it_real_fn. These are probably queued
> for long enough times, around 450 seconds and 2000 seconds.
>
> So, my question is: Why are these getting queued? And how
> can I get rid of those for my case, where I want zero interruption
> on isolated core, as that would be running a userspace thread
> to handle data plane packets.
>
>
> Another thing I tried out recently was to make my single threaded
> task "stress" a real time task with priority 99 (along with cpusets).
> But it seems there are more than one thread getting on that CPU
> and so tick occurs immediately.
>
> I tried to call "stress" with help of chrt.
>
> --
> viresh

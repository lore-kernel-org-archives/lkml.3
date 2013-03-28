Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3C1Cvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:51:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54138 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3C1Cvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:51:46 -0400
Message-ID: <5153B03E.2050201@gmail.com>
Date: Wed, 27 Mar 2013 19:51:42 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dirk.brandewie@gmail.com
Subject: Re: intel_pstate_timer_func divide by zero oops
References: <alpine.LFD.2.03.1303272103380.8412@gmail.com>
In-Reply-To: <alpine.LFD.2.03.1303272103380.8412@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Is there any way to capture the beginning of this trace?

pid_param_set() is on the stack which means that something is changing
the debugfs parameters or the stack is FUBAR.

On 03/27/2013 06:49 PM, Parag Warudkar wrote:
> I get this same oops occassionally - the machine freezes and there doesn't
> seem to be any record of the oops on disk.
>

>
> That  is -
> 	sample->pstate_pct_busy = 100 - div64_u64(
> 					sample->idletime_us * 100,
> 					sample->duration_us);
>

I don't see how duration_us can be zero unless somehow I am getting back-to-back
timer callbacks which seems unlikely since the timer is not re-armed until
the timer function is about to return and the driver has done all its work
for the sample period

--Dirk

> So looks like sample->duration_us is 0? If so, that implies that
> ktime_us_delta(now, cpu->prev_sample) is zero. I am not entirely sure how
> to handle this case - return if sampling too early, or if there is some
> other bug making the delta calculation go poof.
>
>
> Thanks,
>
> Parag
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


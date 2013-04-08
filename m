Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027Ab3DHUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:20:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38307 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935951Ab3DHUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:20:06 -0400
Message-ID: <51632673.8030603@linaro.org>
Date: Mon, 08 Apr 2013 13:20:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Engraf <david.engraf@sysgo.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime_add_ns() may overflow on 32bit architectures
References: <51485A43.4020600@sysgo.com>
In-Reply-To: <51485A43.4020600@sysgo.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 05:29 AM, David Engraf wrote:
> Hello,
>
> I've triggered an overflow when using ktime_add_ns() on a 32bit 
> architecture not supporting CONFIG_KTIME_SCALAR.
>
> When passing a very high value for u64 nsec, e.g. 7881299347898368000 
> the do_div() function converts this value to seconds (7881299347) 
> which is still to high to pass to the ktime_set() function as long. 
> The result in my case is a negative value.
>
> The problem on my system occurs in the tick-sched.c, 
> tick_nohz_stop_sched_tick() when time_delta is set to 
> timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is 
> valid, thus ktime_add_ns() is called with a too large value resulting 
> in a negative expire value. This leads to an endless loop in the 
> ticker code:
>
> time_delta: 7881299347898368000
> expires = ktime_add_ns(last_update, time_delta)
> expires: negative value
>
> This error doesn't occurs on 64bit or architectures supporting 
> CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).

Sorry, this fell through the cracks. I see Andrew caught it, but I've 
queued for 3.10 in my tree as well.

This should be tagged for -stable as well, no?

thanks
-john


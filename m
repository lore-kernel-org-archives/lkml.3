Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab3BYOVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab3BYOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:21:23 -0500
Message-ID: <512B7352.1040209@redhat.com>
Date: Mon, 25 Feb 2013 09:21:06 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
References: <alpine.LFD.2.02.1302222111400.22263@ionos> <1361725480-22270-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1361725480-22270-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/24/2013 12:04 PM, Prarit Bhargava wrote:
> On 02/22/2013 03:14 PM, Thomas Gleixner wrote:
>>> +void clocksource_mark_unstable(struct clocksource *cs) { }
>>
>> Unless this is defined as
>>
>>> +static inline void clocksource_mark_unstable(struct clocksource *cs) { }
>>
>> Right?
> 
> Whups.  Of course ... new patch ...
> 
> -----8<----
> 
> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
> the x86 kernel will not compile unless this is properly defined.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> ---
>  kernel/time/clocksource.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c958338..3d81a76 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -450,6 +450,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
>  static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
>  static inline void clocksource_resume_watchdog(void) { }
>  static inline int clocksource_watchdog_kthread(void *data) { return 0; }
> +static inline void clocksource_mark_unstable(struct clocksource *cs) { }
>  
>  #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */

Yuck.  Self NACK this one ... sorry Thomas.  I'm going to have to do more work
on this patch ...

P.

>  

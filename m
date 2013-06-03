Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3FCTVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:21:32 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36114 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3FCTVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:21:25 -0400
Message-ID: <51ACECB2.40407@linaro.org>
Date: Mon, 03 Jun 2013 12:21:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marcus Gelderie <redmnic@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel:time Export symbols of functions declared
 in linux/alarmtimer.h
References: <1370104746-20993-1-git-send-email-redmnic@gmail.com>
In-Reply-To: <1370104746-20993-1-git-send-email-redmnic@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 09:39 AM, Marcus Gelderie wrote:
> Export symbols so they can be used by
> drivers/staging/android/alarm-dev.c. So far this is built-in but LKM
> support is planned (see drivers/staging/android/TODO).
>
> Signed-off-by: Marcus Gelderie <redmnic@gmail.com>

These probably should be EXPORT_SYMBOL_GPL, no? Also there's a bunch of 
new alarm functions that Todd Poynor that I have queued, which will 
probably need similar.

thanks
-john


> ---
>   kernel/time/alarmtimer.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index f11d83b..90eca2f 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -303,6 +303,7 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
>   	alarm->type = type;
>   	alarm->state = ALARMTIMER_STATE_INACTIVE;
>   }
> +EXPORT_SYMBOL(alarm_init);
>   
>   /**
>    * alarm_start - Sets an alarm to fire
> @@ -323,6 +324,7 @@ int alarm_start(struct alarm *alarm, ktime_t start)
>   	spin_unlock_irqrestore(&base->lock, flags);
>   	return ret;
>   }
> +EXPORT_SYMBOL(alarm_start);
>   
>   /**
>    * alarm_try_to_cancel - Tries to cancel an alarm timer
> @@ -344,7 +346,7 @@ int alarm_try_to_cancel(struct alarm *alarm)
>   	spin_unlock_irqrestore(&base->lock, flags);
>   	return ret;
>   }
> -
> +EXPORT_SYMBOL(alarm_try_to_cancel);
>   
>   /**
>    * alarm_cancel - Spins trying to cancel an alarm timer until it is done
> @@ -361,7 +363,7 @@ int alarm_cancel(struct alarm *alarm)
>   		cpu_relax();
>   	}
>   }
> -
> +EXPORT_SYMBOL(alarm_cancel);
>   
>   u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
>   {
> @@ -393,8 +395,7 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
>   	alarm->node.expires = ktime_add(alarm->node.expires, interval);
>   	return overrun;
>   }
> -
> -
> +EXPORT_SYMBOL(alarm_forward);
>   
>   
>   /**


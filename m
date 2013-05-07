Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab3EGIPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:15:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab3EGIPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:15:21 -0400
Message-ID: <5188B809.5060803@redhat.com>
Date: Tue, 07 May 2013 10:15:05 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: y@shlinux1.ap.freescale.net
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, tglx@linutronix.de,
        john.stultz@linaro.org, liu.y.victor@gmail.com,
        Liu Ying <Ying.Liu@freescale.com>
Subject: Re: [PATCH 1/1] ktime: Use macro NSEC_PER_USEC instead of a magic
 number
References: <y> <1367844135-31383-1-git-send-email-y>
In-Reply-To: <1367844135-31383-1-git-send-email-y>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 02:42 PM, y@shlinux1.ap.freescale.net wrote:
> From: Liu Ying <Ying.Liu@freescale.com>

Nitpick:

If you only have 1 patch, then you don't need "1/1" in the subject.
The term magic number here might be a little exaggerated, not so
magic actually. :-)

But, in general I agree that we could do that also since it is used
elsewhere in the same header file. Thus, this might be more consistent.

> We've got the macro NSEC_PER_USEC defined in header file
> include/linux/time.h. To make the code decent, this patch
> replaces the magic number 1000 to convert bewteen a time
> value in microseconds and one in nanoseconds with the
> macro NSEC_PER_USEC.
>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> ---
>   include/linux/ktime.h |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> index bbca128..5de963d 100644
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -229,7 +229,8 @@ static inline ktime_t timespec_to_ktime(const struct timespec ts)
>   static inline ktime_t timeval_to_ktime(const struct timeval tv)
>   {
>   	return (ktime_t) { .tv = { .sec = (s32)tv.tv_sec,
> -				   .nsec = (s32)tv.tv_usec * 1000 } };
> +				   .nsec = (s32)tv.tv_usec *
> +					   (s32)NSEC_PER_USEC} };

Nitpick: Likely, this could be reduced to one cast only.

Otherwise looks good.

>   }
>
>   /**
> @@ -320,12 +321,12 @@ static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
>
>   static inline ktime_t ktime_add_us(const ktime_t kt, const u64 usec)
>   {
> -	return ktime_add_ns(kt, usec * 1000);
> +	return ktime_add_ns(kt, usec * NSEC_PER_USEC);
>   }
>
>   static inline ktime_t ktime_sub_us(const ktime_t kt, const u64 usec)
>   {
> -	return ktime_sub_ns(kt, usec * 1000);
> +	return ktime_sub_ns(kt, usec * NSEC_PER_USEC);
>   }
>
>   extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
>

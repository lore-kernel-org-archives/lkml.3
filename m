Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaBTStu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:49:50 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47509 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaBTStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:49:49 -0500
Message-ID: <53064E4A.8030105@linaro.org>
Date: Thu, 20 Feb 2014 10:49:46 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
CC: anton@nomsg.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 2/6] hrtimer: Add support for deferrable timer into
 the hrtimer
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-3-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <1392885633-7787-3-git-send-email-a.perevalov@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 12:40 AM, Alexey Perevalov wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> This patch introduces new public CLOCKID constants for
> user space API, such as timerfd. It extends hrtimer API and makes
> possible to have unified interfaces where deferreble functionality is
> used. In-kernel users such as device drivers could find benefits too.
>
> High resolution timer now could work with CLOCK_REALTIME_DEFERRABLE,
> CLOCK_MONOTONIC_DEFERRABLE, CLOCK_BOOTTIME_DEFERRABLE.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/linux/hrtimer.h   |    3 +++
>  include/uapi/linux/time.h |    3 +++
>  kernel/hrtimer.c          |   62 +++++++++++++++++++++++++++++++++++----------
>  3 files changed, 55 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index d19a5c2..fe1159c 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -158,6 +158,9 @@ enum  hrtimer_base_type {
>  	HRTIMER_BASE_REALTIME,
>  	HRTIMER_BASE_BOOTTIME,
>  	HRTIMER_BASE_TAI,
> +	HRTIMER_BASE_MONOTONIC_DEFERRABLE,
> +	HRTIMER_BASE_REALTIME_DEFERRABLE,
> +	HRTIMER_BASE_BOOTTIME_DEFERRABLE,
>  	HRTIMER_MAX_CLOCK_BASES,
>  };
>  
> diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
> index e75e1b6..bb8dc60 100644
> --- a/include/uapi/linux/time.h
> +++ b/include/uapi/linux/time.h
> @@ -56,6 +56,9 @@ struct itimerval {
>  #define CLOCK_BOOTTIME_ALARM		9
>  #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
>  #define CLOCK_TAI			11
> +#define CLOCK_REALTIME_DEFERRABLE	12
> +#define CLOCK_MONOTONIC_DEFERRABLE	13
> +#define CLOCK_BOOTTIME_DEFERRABLE	14

Adding the deferrable HRTIMER bases above is right, but I don't think we
agreed on adding the _DEFERRABLE clockids.

I'd instead prefer you use add a new TIMER_DEFERABLE flags argument, and
use the combination of the clockid + flag to decide which HRTIMER base
is used.

thanks
-john


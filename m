Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3F0RjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:39:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59961 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3F0RjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:39:08 -0400
Message-ID: <51CC78B8.3050709@linaro.org>
Date: Thu, 27 Jun 2013 10:39:04 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] time: pass flags instead of multiple bools to timekeeping_update()
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1372329348-20841-3-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:35 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> Instead of passing multiple bools to timekeeping_updated(), define
> flags and use a single 'action' parameter.  It is then more obvious
> what each timekeeping_update() call does.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>   kernel/time/timekeeping.c |   21 ++++++++++++---------
>   1 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index baeeb5c..7aed2b0 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -26,6 +26,9 @@
>   #include "tick-internal.h"
>   #include "ntp_internal.h"
>   
> +#define TK_CLEAR_NTP (1 << 0)
> +#define TK_MIRROR (1 << 1)
> +
>   static struct timekeeper timekeeper;
>   static DEFINE_RAW_SPINLOCK(timekeeper_lock);
>   static seqcount_t timekeeper_seq;
> @@ -241,16 +244,16 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
>   EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
>   
>   /* must hold timekeeper_lock */
> -static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
> +static void timekeeping_update(struct timekeeper *tk, unsigned action)

Nit: Mind making this "unsigned int" just for consistency sake with the 
rest of the code?

thanks
-john


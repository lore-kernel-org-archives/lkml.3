Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3JJEEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:04:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54173 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJEEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:04:53 -0400
Message-ID: <52562760.9010400@linaro.org>
Date: Wed, 09 Oct 2013 21:04:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dong Zhu <bluezhudong@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] timer stats: reset entries when disable the timer
 usage statistics
References: <20131010025947.GD2139@zhudong.nay.redhat.com>
In-Reply-To: <20131010025947.GD2139@zhudong.nay.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 07:59 PM, Dong Zhu wrote:
> From f41628c61d8a9172677ba33a55b61e37ce28f7a6 Mon Sep 17 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com> 
> Date: Thu, 10 Oct 2013 10:38:13 +0800
>
> When we stop timer statistics collection (via echo 0 >
> /proc/timers_stats), the statistics data is still exported as if it were
> correct, which can cause applicaitons to misuse the statistics.
>
> This patch resets the statistics when we stop collecting them, to avoid
> this problem.
>
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> ---
>  kernel/time/timer_stats.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> index 0b537f2..43f05e7 100644
> --- a/kernel/time/timer_stats.c
> +++ b/kernel/time/timer_stats.c
> @@ -371,6 +371,7 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
>  	switch (ctl[0]) {
>  	case '0':
>  		if (timer_stats_active) {
> +			reset_entries();
>  			timer_stats_active = 0;
>  			time_stop = ktime_get();
>  			sync_access();

This looks ok to me. Thomas, do you have any objections here?

thanks
-john


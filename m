Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3AJUMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:12:19 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44237 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3AJUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:12:17 -0500
Date: Thu, 10 Jan 2013 21:12:07 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] posix-timers: Fix clock_adjtime to return timex data
 on success
Message-ID: <20130110201205.GE2909@netboy.at.omicron.at>
References: <1357837922-1555-1-git-send-email-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357837922-1555-1-git-send-email-mlichvar@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 06:12:02PM +0100, Miroslav Lichvar wrote:
> Copy the modified timex data back to the user also with positive return
> values. This fixes reading of the CLOCK_REALTIME timex data when the
> clock is in a non-zero state.
> 
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

(Adding John Stultz on CC)

> ---
>  kernel/posix-timers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 69185ae..10349d5 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -997,7 +997,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
>  
>  	err = kc->clock_adj(which_clock, &ktx);
>  
> -	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
> +	if (err >= 0 && copy_to_user(utx, &ktx, sizeof(ktx)))
>  		return -EFAULT;
>  
>  	return err;
> -- 
> 1.7.11.7
> 

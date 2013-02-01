Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3BAO7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:59:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab3BAO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:59:45 -0500
Date: Fri, 1 Feb 2013 09:59:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        chuansheng.liu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
Message-ID: <20130201145934.GQ98867@redhat.com>
References: <1359726547-21205-1-git-send-email-anish198519851985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359726547-21205-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 07:19:07PM +0530, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> Uses are:
> 1. Check if smpboot_register_percpu_thread function passed.
> 2. Makes sure that user enables and disables the watchdog in sequence
>    i.e. enable watchdog->disable watchdog->enable watchdog
>    Unlike enable watchdog->enable watchdog which is wrong.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  kernel/watchdog.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 6ef638b..dfd843a 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -519,6 +519,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>  		return ret;
>  
>  	set_sample_period();
> +	/*
> +	 * We shouldn't enable watchdog threads if it is not
							^^^
the 'not' is not needed I believe.  Other than that, if it helps
to understand the code better.  I am fine with it.

Acked-by: Don Zickus <dzickus@redhat.com>

> +	 * disabled.This is done by watchdog_disabled
> +	 * variable check in watchdog_*_all_cpus function.
> +	 */
>  	if (watchdog_enabled && watchdog_thresh)
>  		watchdog_enable_all_cpus();
>  	else
> -- 
> 1.7.1
> 

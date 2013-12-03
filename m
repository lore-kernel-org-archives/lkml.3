Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3LCW1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:27:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab3LCW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:27:53 -0500
Date: Tue, 3 Dec 2013 14:27:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Zhang <benzh@chromium.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] watchdog: Add a sysctl to disable soft lockup detector
Message-Id: <20131203142751.34475fce138ce996d22db784@linux-foundation.org>
In-Reply-To: <1386107674-15903-1-git-send-email-benzh@chromium.org>
References: <1386107674-15903-1-git-send-email-benzh@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Dec 2013 13:54:34 -0800 Ben Zhang <benzh@chromium.org> wrote:

> This provides usermode a way to disable only the soft
> lockup detector while keeping the hard lockup detector
> running.

Please update the changelog to describe the current behavior.

Please also describe why you think that behavior should be changed. 
ie: what's the reason for this patch.

Please update Documentation/ for this feature.  Probably that's
kernel-parameters.txt for the boot option and sysctl/kernel.txt for the
procfs addition.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -270,6 +270,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
>  				  void __user *buffer,
>  				  size_t *lenp, loff_t *ppos);
>  extern unsigned int  softlockup_panic;
> +extern unsigned int  softlockup_detector_enable;

Remove unneeded space while we're in there.

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -840,6 +840,15 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  	{
> +		.procname	= "softlockup_detector_enable",
> +		.data		= &softlockup_detector_enable,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},

And let's describe the full procfs path to this pseudo-file within the
changelog.

>  		.procname       = "nmi_watchdog",
>  		.data           = &watchdog_user_enabled,
>  		.maxlen         = sizeof (int),


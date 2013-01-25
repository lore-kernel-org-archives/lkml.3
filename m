Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3AYQBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:01:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53019 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3AYQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:01:09 -0500
MIME-Version: 1.0
In-Reply-To: <1359123276-15833-6-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-6-git-send-email-arnd@arndb.de>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Jan 2013 08:00:36 -0800
Message-ID: <CAPM31RJGMHw9mZYxsyFfC1AudhPSzuEt4ZTEdCVGmM3PHQFOuw@mail.gmail.com>
Subject: Re: [PATCH 05/19] sched: warnings in kernel/sched/fair.c
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 6:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> a4c96ae319 "sched: Unthrottle rt runqueues in __disable_runtime()"
> turned the unthrottle_offline_cfs_rqs function into a static symbol,
> which now triggers a warning about it being potentially unused:
>
> kernel/sched/fair.c:2055:13: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]
>
> Marking it __maybe_unused shuts up the gcc warning and lets the
> compiler safely drop the function body when it's not being used.
>
> To reproduce, build the ARM bcm2835_defconfig.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Turner <pjt@google.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5eea870..81fa536 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2663,7 +2663,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>         hrtimer_cancel(&cfs_b->slack_timer);
>  }
>
> -static void unthrottle_offline_cfs_rqs(struct rq *rq)
> +static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)

Looks good.

Reviewed-by: Paul Turner <pjt@google.com>

>  {
>         struct cfs_rq *cfs_rq;
>
> --
> 1.8.0
>

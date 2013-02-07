Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3BGKdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:33:20 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39718 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BGKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-4-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<1360170133-5066-4-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 16:03:16 +0530
X-Google-Sender-Auth: qRI-iqrbL0Gh37YrLYsjVeuMBY8
Message-ID: <CAOh2x=mjWxSM+WzReHgbnjHmft7yiP6OOf5p-kwpqh2Ykp_O0A@mail.gmail.com>
Subject: Re: [PATCH 2/5] cpufreq: Only call cpufreq_out_of_sync() with drivers
 that implement cpufreq_driver.target()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:32 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement cpufreq_driver.setpolicy() have
> internal governors that do not signal changes via
> cpufreq_notify_transition() so the frequncy in the policy will almost
> certainly be different than the current frequncy.  Only call
> cpufreq_out_of_sync() when the underlying driver implements
> cpufreq_driver.target()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index bb45f93..0ba0344 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1798,7 +1798,7 @@ int cpufreq_update_policy(unsigned int cpu)
>                         pr_debug("Driver did not initialize current freq");
>                         data->cur = policy.cur;
>                 } else {
> -                       if (data->cur != policy.cur)
> +                       if (data->cur != policy.cur && driver->target)
>                                 cpufreq_out_of_sync(cpu, data->cur,
>                                                                 policy.cur);

Looks much better now :)

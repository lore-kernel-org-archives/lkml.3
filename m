Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3KSOdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:33:01 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63048 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3KSOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:32:57 -0500
MIME-Version: 1.0
In-Reply-To: <1384867758-15276-1-git-send-email-jhbird.choi@samsung.com>
References: <1384867758-15276-1-git-send-email-jhbird.choi@samsung.com>
Date: Tue, 19 Nov 2013 20:02:56 +0530
Message-ID: <CAKohpo=kELQ+7pcWkTYnDOds8YktQMD4F-=gL3jywaWfNe6CNA@mail.gmail.com>
Subject: Re: [PATCH 2/4] cpufreq: exynos: Consider hibernation in pm notifier
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2013 18:59, Jonghwan Choi <jhbird.choi@gmail.com> wrote:
> Frequency lock should be considered in suspend/hibernation.

These could turn out to be important logs for future. Please write
with more effort..

> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index f3c2287..cd05b0a 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -187,6 +187,7 @@ static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
>         int ret;
>
>         switch (pm_event) {
> +       case PM_HIBERNATION_PREPARE:
>         case PM_SUSPEND_PREPARE:
>                 mutex_lock(&cpufreq_lock);
>                 frequency_locked = true;
> @@ -198,6 +199,8 @@ static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
>
>                 break;
>
> +       case PM_POST_HIBERNATION:
> +       case PM_POST_RESTORE:
>         case PM_POST_SUSPEND:
>                 mutex_lock(&cpufreq_lock);
>                 frequency_locked = false;

@Rafael: So we have few more drivers which are already doing such
stuff (even tegra as well)..

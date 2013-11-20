Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3KTJqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:46:47 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:53413 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3KTJqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:46:44 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
References: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
Date: Wed, 20 Nov 2013 18:46:43 +0900
X-Google-Sender-Auth: xNheWXPl_NhbgNt5xwY0V3lehQs
Message-ID: <CAJ0PZbRJLB_WcOkFq_e=DBCR7ABYoin-voBtbq61Pqd_wyzwmw@mail.gmail.com>
Subject: Re: [PATCH 4/4] PM / devfreq: Consider hibernation in pm notifier
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:30 PM, Jonghwan Choi <jhbird.choi@gmail.com> wrote:
> Frequency lock should be considered in suspend/hibernation.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>




Cheers,
MyungJoo.

> ---
>  drivers/devfreq/exynos/exynos5_bus.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
> index a60da3c..bd672de0 100644
> --- a/drivers/devfreq/exynos/exynos5_bus.c
> +++ b/drivers/devfreq/exynos/exynos5_bus.c
> @@ -268,6 +268,7 @@ static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
>         int err = 0;
>
>         switch (event) {
> +       case PM_HIBERNATION_PREPARE:
>         case PM_SUSPEND_PREPARE:
>                 /* Set Fastest and Deactivate DVFS */
>                 mutex_lock(&data->lock);
> @@ -300,6 +301,7 @@ unlock:
>                 if (err)
>                         return NOTIFY_BAD;
>                 return NOTIFY_OK;
> +       case PM_POST_HIBERNATION:
>         case PM_POST_RESTORE:
>         case PM_POST_SUSPEND:
>                 /* Reactivate */
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics

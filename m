Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3GRK4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:56:24 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:64032 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3GRK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <1374144831-25622-1-git-send-email-broonie@kernel.org>
References: <1374144831-25622-1-git-send-email-broonie@kernel.org>
Date: Thu, 18 Jul 2013 16:26:22 +0530
Message-ID: <CAKohpo=VqJA7m_p7YSNZjkY6Se640RJEHSdJdX6BwY+VGSfAng@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Use the power efficient workqueue for
 delayed powerdown
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2013 16:23, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> There is no need to use a normal per-CPU workqueue for delayed power downs
> as they're not timing or performance critical and waking up a core for them
> would defeat some of the point.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index b6efead..6ef476f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1891,8 +1891,9 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
>         rdev->deferred_disables++;
>         mutex_unlock(&rdev->mutex);
>
> -       ret = schedule_delayed_work(&rdev->disable_work,
> -                                   msecs_to_jiffies(ms));
> +       ret = queue_delayed_work(system_power_efficient_wq,
> +                                &rdev->disable_work,
> +                                msecs_to_jiffies(ms));
>         if (ret < 0)
>                 return ret;
>         else

Cool!! People have started to use this interface now :)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

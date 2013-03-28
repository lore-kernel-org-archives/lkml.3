Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3C1GDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:03:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60655 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3C1GDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:03:14 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1364392374-12236-2-git-send-email-rajagopal.venkat@linaro.org>
References: <1364392374-12236-1-git-send-email-rajagopal.venkat@linaro.org>
	<1364392374-12236-2-git-send-email-rajagopal.venkat@linaro.org>
Date: Thu, 28 Mar 2013 15:03:12 +0900
X-Google-Sender-Auth: K35zaavy1Mpr4CGgritjhNLxxzk
Message-ID: <CAJ0PZbQNTLEmJQ_sRnByNCzwTKs84dGA7Ap2Yj5KRPefoeNsyw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] PM / devfreq: Fix compiler warnings
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: rjw@sisk.pl, Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:52 PM, Rajagopal Venkat
<rajagopal.venkat@linaro.org> wrote:
> Fix compiler warnings generated when devfreq is not enabled
> (CONFIG_PM_DEVFREQ is not set).
>
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

Thanks!

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


> ---
>  include/linux/devfreq.h |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 04ad61d..5f1ab92 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -215,7 +215,7 @@ struct devfreq_simple_ondemand_data {
>  #endif
>
>  #else /* !CONFIG_PM_DEVFREQ */
> -static struct devfreq *devfreq_add_device(struct device *dev,
> +static inline struct devfreq *devfreq_add_device(struct device *dev,
>                                           struct devfreq_dev_profile *profile,
>                                           const char *governor_name,
>                                           void *data)
> @@ -223,34 +223,34 @@ static struct devfreq *devfreq_add_device(struct device *dev,
>         return NULL;
>  }
>
> -static int devfreq_remove_device(struct devfreq *devfreq)
> +static inline int devfreq_remove_device(struct devfreq *devfreq)
>  {
>         return 0;
>  }
>
> -static int devfreq_suspend_device(struct devfreq *devfreq)
> +static inline int devfreq_suspend_device(struct devfreq *devfreq)
>  {
>         return 0;
>  }
>
> -static int devfreq_resume_device(struct devfreq *devfreq)
> +static inline int devfreq_resume_device(struct devfreq *devfreq)
>  {
>         return 0;
>  }
>
> -static struct opp *devfreq_recommended_opp(struct device *dev,
> +static inline struct opp *devfreq_recommended_opp(struct device *dev,
>                                            unsigned long *freq, u32 flags)
>  {
> -       return -EINVAL;
> +       return ERR_PTR(-EINVAL);
>  }
>
> -static int devfreq_register_opp_notifier(struct device *dev,
> +static inline int devfreq_register_opp_notifier(struct device *dev,
>                                          struct devfreq *devfreq)
>  {
>         return -EINVAL;
>  }
>
> -static int devfreq_unregister_opp_notifier(struct device *dev,
> +static inline int devfreq_unregister_opp_notifier(struct device *dev,
>                                            struct devfreq *devfreq)
>  {
>         return -EINVAL;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics

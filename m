Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3BVEt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:49:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56104 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3BVEt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:49:27 -0500
Date: Thu, 21 Feb 2013 22:49:17 -0600
From: Nishanth Menon <nm@ti.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <myungjoo.ham@samsung.com>, <kyungmin.park@samsung.com>,
        <yongjun_wei@trendmicro.com.cn>, <linux-kernel@vger.kernel.org>,
        <rjw@sisk.pl>
Subject: Re: [PATCH] PM / devfreq: fix missing unlock on error in
 exynos4_busfreq_pm_notifier_event()
Message-ID: <20130222044917.GA24752@kahuna>
References: <CAPgLHd-xToKRxXtknB0O3DZnaqEAqJ4cXpV_HHnJNs0Gx9OVPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-xToKRxXtknB0O3DZnaqEAqJ4cXpV_HHnJNs0Gx9OVPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:33-20130222, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function
> exynos4_busfreq_pm_notifier_event() in the error
> handling case.
> 
> This issue introduced by commit 8fa938
> (PM / devfreq: exynos4_bus: honor RCU lock usage)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/devfreq/exynos4_bus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 46d94e9..6208a68 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -974,6 +974,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
>  			rcu_read_unlock();
>  			dev_err(data->dev, "%s: unable to find a min freq\n",
>  				__func__);
> +			mutex_unlock(&data->lock);
>  			return PTR_ERR(opp);
>  		}
>  		new_oppinfo.rate = opp_get_freq(opp);
> 
> 
Arrgh.. Thanks for catching this :( My bad.

Fix looks good to me. upto  MyungJoo.

MyungJoo, Rafael,
btw, adding linux-pm@vger.kernel.org to  MAINTAINERS for devfreq might
be a nice idea to have right audience.
-- 
Regards,
Nishanth Menon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaEOIqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:46:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:42956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaEOIqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="539434507"
Message-ID: <1400143528.2273.30.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal: samsung: Only update available threshold limits
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Kachhap <amit.kachhap@gmail.com>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        eduardo.valentin@ti.com
Date: Thu, 15 May 2014 16:45:28 +0800
In-Reply-To: <CADGdYn719UzdPd3fVWrPi=mTnKvKy3O5bPHZcn8xCFjrAWp7yA@mail.gmail.com>
References: <1397453895-6688-1-git-send-email-tushar.behera@linaro.org>
	 <CADGdYn719UzdPd3fVWrPi=mTnKvKy3O5bPHZcn8xCFjrAWp7yA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2014-04-24 at 11:48 +0530, Amit Kachhap wrote:
> On 4/14/14, Tushar Behera <tushar.behera@linaro.org> wrote:
> > Currently the threshold limits are updated in 2 stages, once for all
> > software trigger levels and again for hardware trip point.
> I guess the first stage is bootloader as could not find this in this file.
> Anyways the changes looks fine to me.
> 
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

applied.

thanks,
rui
> 
> >
> > While updating the software trigger levels, it overwrites the threshold
> > limit for hardware trip point thereby forcing the Exynos core to issue
> > an emergency shutdown.
> >
> > Updating only the required fields in threshold register fixes this issue.
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > ---
> > Based on v3.15-rc1.
> >
> >  drivers/thermal/samsung/exynos_tmu.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > b/drivers/thermal/samsung/exynos_tmu.c
> > index 0d96a51..ffccc89 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -225,6 +225,8 @@ skip_calib_data:
> >  			trigger_levs++;
> >  	}
> >
> > +	rising_threshold = readl(data->base + reg->threshold_th0);
> > +
> >  	if (data->soc == SOC_ARCH_EXYNOS4210) {
> >  		/* Write temperature code for threshold */
> >  		threshold_code = temp_to_code(data, pdata->threshold);
> > @@ -249,6 +251,7 @@ skip_calib_data:
> >  				ret = threshold_code;
> >  				goto out;
> >  			}
> > +			rising_threshold &= ~(0xff << 8 * i);
> >  			rising_threshold |= threshold_code << 8 * i;
> >  			if (pdata->threshold_falling) {
> >  				threshold_code = temp_to_code(data,
> > @@ -281,6 +284,7 @@ skip_calib_data:
> >  			}
> >  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
> >  				/* 1-4 level to be assigned in th0 reg */
> > +				rising_threshold &= ~(0xff << 8 * i);
> >  				rising_threshold |= threshold_code << 8 * i;
> >  				writel(rising_threshold,
> >  					data->base + reg->threshold_th0);
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >



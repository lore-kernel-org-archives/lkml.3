Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3H2NRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:17:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42473 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3H2NR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:17:29 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c7-521f49e7206f
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com, m.chehab@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 4/6] media: s5p-tv: Fix mixer driver to work with CCF
Date: Thu, 29 Aug 2013 15:17:23 +0200
Message-id: <6962075.17ypj6ChmC@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377706384-3697-5-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-5-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t/xq7rPPeWDDJZd1bOYtO4Ak8X8I+dY
	Ld70drBY9C64ymZxtukNu8Wmx9dYLRa2LWGxuLxrDptFz4atrBYzzu9jsrh9mdfi4jp5i9Nr
	TjFbLL1+kcni6YSLbBYTpq9lsTi8AmjaupfTgaw37awWrw62sVjMa3/JanFsxhJGi1W7/jA6
	iHusmbeG0aOluYfNY8HnK+werydPYPT4u+oFs8fOWXfZPV6tnsnqcefaHjaPzUvqPQ6+28Pk
	0bdlFaPH501yHhvnhgbwRnHZpKTmZJalFunbJXBl3FzYyliwWLRiy5WPLA2MRwW7GDk5JARM
	JF7dnskMYYtJXLi3nq2LkYtDSGApo8TkT7cYIZwuJolDVw+DVbEJqEl8bnjEBmKLCJhKvLt7
	DayDWWA/i8TTtZMYQRLCAj4SS49fZe9i5OBgEVCV2NucChLmFdCU2PJgJxOIzS+gLvFu21Mm
	kBJRAReJvr+ZIGFOAT+J+S+fM0HsncgoMWXqHCaIXkGJH5PvsYDYzALyEvv2T2WFsLUk1u88
	zjSBUXAWkrJZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkzr/uYFx6zOoQ
	owAHoxIPL8NP2SAh1sSy4srcQ4wSHMxKIrxvOeWDhHhTEiurUovy44tKc1KLDzEycXBKNTAK
	bvV44H1U15/vfOzalw6Wxge8z606YXNAaeqEtMyVHuGnUkOm6lpf27tu46ML95/fOzTPZY/C
	hfgQCc5Jm2VPW9fMmR/3+WLFqdeeHveeW7g9bIp06i3tdJT5e+LXI565lz7qdYeqyLbsfD7h
	1Q6m8NRbd47u4e+fEVUSFNKUnu9vKeI4n7laiaU4I9FQi7moOBEAD8uFe9ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 of August 2013 18:13:02 Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with
> clk_disable_unprepare. Clock prepare is required by Clock Common
> Framework, and old clock driver didn`t support it. Without it Common
> Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/mixer_drv.c | 35
> ++++++++++++++++++++++++------- 1 file changed, 28 insertions(+), 7
> deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c
> b/drivers/media/platform/s5p-tv/mixer_drv.c index 8ce7c3e..3b2b305
> 100644
> --- a/drivers/media/platform/s5p-tv/mixer_drv.c
> +++ b/drivers/media/platform/s5p-tv/mixer_drv.c
> @@ -347,19 +347,40 @@ static int mxr_runtime_resume(struct device *dev)
>  {
>  	struct mxr_device *mdev = to_mdev(dev);
>  	struct mxr_resources *res = &mdev->res;
> +	int ret;
> 
>  	dev_dbg(mdev->dev, "resume - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks on */
> -	clk_enable(res->mixer);
> -	clk_enable(res->vp);
> -	clk_enable(res->sclk_mixer);
> +	ret = clk_prepare_enable(res->mixer);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(mixer) failed\n");
> +		goto fail;
> +	}
> +	ret = clk_prepare_enable(res->vp);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(vp) failed\n");
> +		goto fail_mixer;
> +	}
> +	ret = clk_prepare_enable(res->sclk_mixer);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(sclk_mixer) failed\n");
> +		goto fail_vp;
> +	}
>  	/* apply default configuration */
>  	mxr_reg_reset(mdev);
> -	dev_dbg(mdev->dev, "resume - finished\n");
> 
>  	mutex_unlock(&mdev->mutex);
> +	dev_dbg(mdev->dev, "resume - finished\n");

Why is this line moved in this patch?

>  	return 0;

nit: A blank line would look good here.

> +fail_vp:
> +	clk_disable_unprepare(res->vp);
> +fail_mixer:
> +	clk_disable_unprepare(res->mixer);
> +fail:
> +	mutex_unlock(&mdev->mutex);
> +	dev_info(mdev->dev, "resume failed\n");

dev_err?

Best regards,
Tomasz

> +	return ret;
>  }
> 
>  static int mxr_runtime_suspend(struct device *dev)
> @@ -369,9 +390,9 @@ static int mxr_runtime_suspend(struct device *dev)
>  	dev_dbg(mdev->dev, "suspend - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks off */
> -	clk_disable(res->sclk_mixer);
> -	clk_disable(res->vp);
> -	clk_disable(res->mixer);
> +	clk_disable_unprepare(res->sclk_mixer);
> +	clk_disable_unprepare(res->vp);
> +	clk_disable_unprepare(res->mixer);
>  	mutex_unlock(&mdev->mutex);
>  	dev_dbg(mdev->dev, "suspend - finished\n");
>  	return 0;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3HZPcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:32:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8631 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3HZPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:32:34 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e8-521b750f5261
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        tomasz.figa@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 1/5] media: s5p-tv: Fix sdo driver to work with CCF
Date: Mon, 26 Aug 2013 17:32:05 +0200
Message-id: <3259807.j0POtVdD7o@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1377517114-20222-2-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-2-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQV3+Uukgg0/dyhbzj5xjtXjT28Fi
	0bvgKpvF2aY37BabHl9jtVjYtoTF4vKuOWwWM87vY7K4fZnX4uI6eYvTa04xW7zuO8xisfT6
	RSaLpxMusllMmL6WxeLwigNMFuteTgey3rSzWrw62MZisX7GaxaLee0vWS2OzVjCaLFq1x9G
	B3GPNfPWMHq0NPeweSz4fIXd4/XkCYweO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWM
	Ht2fbrF6fN4k57FxbmgAbxSXTUpqTmZZapG+XQJXxq7ZC5kLpmpW7DvTztrAOFmxi5GTQ0LA
	ROLCzEcsELaYxIV769lAbCGB6YwS246UdTFyAdktTBJr784GS7AJWElMbF/FCGKLCJhKvLt7
	jQ2kiFlgF4vE2wcrmLsYOTiEBbwlbnTXg9SwCKhKvPq0iBnE5hXQlJh2ewFYr6iAq8S5RT/A
	FnMK+EtcOnWFHWLZZEaJ/QsWQzUISvyYfA+siFlAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRs
	FpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/mZ9A7GVQ0WhxgFOBiVeHgD2KSD
	hFgTy4orcw8xSnAwK4nwcqQChXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5N
	LUgtgskycXBKNTDm7GBJY/RW2XOucb/OdQeJ2DyDxiv/BF7cVa07+65KfOH+FeoTddwk34X2
	m9y4e9x7zeOqfw/7OX7kr+z48e55iTbXL+mfXI7hXeIGh/Pm2p7nc65jWxAdb+XyLXq2+Onw
	FTeLvlq2/dJcpl56bn7mizuHGSKEi7/MCHmlqeurv97C9c6nNw+UWIozEg21mIuKEwF9UD9E
	4wIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 26, 2013 01:38:30 PM Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
> Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
> Without it Common Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c | 44 +++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> index 0afa90f..77eac6d 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -55,6 +55,8 @@ struct sdo_device {
>  	struct clk *dacphy;
>  	/** clock for control of VPLL */
>  	struct clk *fout_vpll;
> +	/** vpll rate before sdo stream was on */
> +	int vpll_rate;
>  	/** regulator for SDO IP power */
>  	struct regulator *vdac;
>  	/** regulator for SDO plug detection */
> @@ -193,17 +195,34 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
>  
>  static int sdo_streamon(struct sdo_device *sdev)
>  {
> +	int ret = 0;

There is no need to initialize ret to 0 here.

>  	/* set proper clock for Timing Generator */
> -	clk_set_rate(sdev->fout_vpll, 54000000);
> +	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
> +	ret = clk_set_rate(sdev->fout_vpll, 54000000);
> +	if (ret < 0) {
> +		dev_err(sdev->dev,
> +			"%s: Failed to set vpll rate!\n", __func__);
> +		return ret;
> +	}
>  	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
>  	clk_get_rate(sdev->fout_vpll));
>  	/* enable clock in SDO */
>  	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	clk_enable(sdev->dacphy);
> +	ret = clk_prepare_enable(sdev->dacphy);
> +	if (ret < 0) {
> +		dev_err(sdev->dev,
> +			"%s: Failed to prepare and enable clock !\n", __func__);
> +		goto fail;
> +	}
>  	/* enable DAC */
>  	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
>  	sdo_reg_debug(sdev);
>  	return 0;
> +fail:
> +	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);

There is not a word about this change in the patch description.

> +	return ret;
>  }
>  
>  static int sdo_streamoff(struct sdo_device *sdev)
> @@ -211,7 +230,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	int tries;
>  
>  	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
> -	clk_disable(sdev->dacphy);
> +	clk_disable_unprepare(sdev->dacphy);
>  	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
>  	for (tries = 100; tries; --tries) {
>  		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
> @@ -220,6 +239,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	}
>  	if (tries == 0)
>  		dev_err(sdev->dev, "failed to stop streaming\n");
> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);

ditto

sdev->fout_vpll rate related changes should be moved to a separate patch
(or at least described properly in the patch description).

>  	return tries ? 0 : -EIO;
>  }
>  
> @@ -254,7 +274,7 @@ static int sdo_runtime_suspend(struct device *dev)
>  	dev_info(dev, "suspend\n");
>  	regulator_disable(sdev->vdet);
>  	regulator_disable(sdev->vdac);
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return 0;
>  }
>  
> @@ -266,7 +286,7 @@ static int sdo_runtime_resume(struct device *dev)
>  
>  	dev_info(dev, "resume\n");
>  
> -	ret = clk_enable(sdev->sclk_dac);
> +	ret = clk_prepare_enable(sdev->sclk_dac);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -299,7 +319,7 @@ static int sdo_runtime_resume(struct device *dev)
>  vdac_r_dis:
>  	regulator_disable(sdev->vdac);
>  dac_clk_dis:
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return ret;
>  }
>  
> @@ -403,10 +423,14 @@ static int sdo_probe(struct platform_device *pdev)
>  		ret = PTR_ERR(sdev->vdet);
>  		goto fail_fout_vpll;
>  	}
> -
>  	/* enable gate for dac clock, because mixer uses it */
> -	clk_enable(sdev->dac);
> -
> +	clk_prepare_enable(sdev->dac);
> +	if (IS_ERR(sdev->dac)) {

It doesn't seem correct to check sdev->dac with IS_ERR() here, especially
since we have the following code earlier:

	sdev->dac = clk_get(dev, "dac");
	if (IS_ERR(sdev->dac)) {
		dev_err(dev, "failed to get clock 'dac'\n");
		ret = PTR_ERR(sdev->dac);
		goto fail_sclk_dac;
	}

I think you should just check clk_prepare_enable() return value instead.

> +		dev_err(dev,
> +			"%s: Failed to prepare and enable clock !\n", __func__);
> +		ret = PTR_ERR(sdev->dac);
> +		goto fail_fout_vpll;
> +	}
>  	/* configure power management */
>  	pm_runtime_enable(dev);
>  
> @@ -444,7 +468,7 @@ static int sdo_remove(struct platform_device *pdev)
>  	struct sdo_device *sdev = sd_to_sdev(sd);
>  
>  	pm_runtime_disable(&pdev->dev);
> -	clk_disable(sdev->dac);
> +	clk_disable_unprepare(sdev->dac);
>  	clk_put(sdev->fout_vpll);
>  	clk_put(sdev->dacphy);
>  	clk_put(sdev->dac);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


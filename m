Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3H2NOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:14:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42175 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3H2NOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:14:51 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-96-521f494833fc
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
Subject: Re: [PATCH v3 3/6] media: s5p-tv: Fix sdo driver to work with CCF
Date: Thu, 29 Aug 2013 15:14:44 +0200
Message-id: <2653159.4aiM8FeBLq@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377706384-3697-4-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-4-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xq7oenvJBBtfe2FhMWneAyWL+kXOs
	Fm96O1gsehdcZbM42/SG3WLT42usFgvblrBYXN41h82iZ8NWVosZ5/cxWdy+zGtxcZ28xek1
	p5gtll6/yGTxdMJFNosJ09eyWBxeATRt3cvpQNabdlaLVwfbWCzmtb9ktTg2Ywmjxapdfxgd
	xD3WzFvD6NHS3MPmseDzFXaP15MnMHr8XfWC2WPnrLvsHq9Wz2T1uHNtD5vH5iX1Hgff7WHy
	6NuyitHj8yY5j41zQwN4o7hsUlJzMstSi/TtErgyjk14xl4wRa7iwqX9rA2MByS6GDk5JARM
	JGbP3MsEYYtJXLi3nq2LkYtDSGApo8SXfxdZIZwuJom/a/6xgVSxCahJfG54BGaLCJhKvLt7
	DayDWWA/i8TTtZMYuxg5OIQFvCQOzVcHqWERUJWYuWcZK0iYV0BTYtdqe5Awv4C6xLttT5lA
	wqICLhJ9fzNBwpwCfhIzPvxmhFg7kVFi8s2V7CAJXgFBiR+T77GA2MwC8hL79k9lhbC1JNbv
	PM40gVFwFpKyWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJMq/7GBcfMzq
	EKMAB6MSD+8OA/kgIdbEsuLK3EOMEhzMSiK8bzmBQrwpiZVVqUX58UWlOanFhxiZODilGhhX
	8MqYKGmkfH/3P1FQ9dDENfk6JVlX3dWlixQezixLPH9NY852+8i3yhkdCm/Xrwvf93q9dPWR
	eyndJpc2fBX/8/lRiJPoFznX7Tv6GczZn4TfKIvQFmSq3FKx90R2qGxhftYySXkL1vwPSloc
	WWW/T1woOc0TUdLnpDHfVP1TY8oVo39nfiixFGckGmoxFxUnAgCTqQa10AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Wednesday 28 of August 2013 18:13:01 Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with
> clk_disable_unprepare. Clock prepare is required by Clock Common
> Framework, and old clock driver didn`t support it. Without it Common
> Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c
> b/drivers/media/platform/s5p-tv/sdo_drv.c index 9dbdfe6..a79e620 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -209,10 +209,10 @@ static int sdo_streamon(struct sdo_device *sdev)
>  	clk_get_rate(sdev->fout_vpll));
>  	/* enable clock in SDO */
>  	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	ret = clk_enable(sdev->dacphy);
> +	ret = clk_prepare_enable(sdev->dacphy);
>  	if (ret < 0) {
>  		dev_err(sdev->dev,
> -			"clk_enable(dacphy) failed !\n");
> +			"clk_prepare_enable(dacphy) failed !\n");

nit: I haven't noticed this when reviewing previous patch, but please tone 
down those errors messages a bit, by removing the exclamation mark (and the 
space before it). We shouldn't be shouting at users. ;)

>  		goto fail;
>  	}
>  	/* enable DAC */
> @@ -230,7 +230,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	int tries;
> 
>  	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
> -	clk_disable(sdev->dacphy);
> +	clk_disable_unprepare(sdev->dacphy);
>  	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
>  	for (tries = 100; tries; --tries) {
>  		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
> @@ -274,7 +274,7 @@ static int sdo_runtime_suspend(struct device *dev)
>  	dev_info(dev, "suspend\n");
>  	regulator_disable(sdev->vdet);
>  	regulator_disable(sdev->vdac);
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return 0;
>  }
> 
> @@ -286,7 +286,7 @@ static int sdo_runtime_resume(struct device *dev)
> 
>  	dev_info(dev, "resume\n");
> 
> -	ret = clk_enable(sdev->sclk_dac);
> +	ret = clk_prepare_enable(sdev->sclk_dac);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -319,7 +319,7 @@ static int sdo_runtime_resume(struct device *dev)
>  vdac_r_dis:
>  	regulator_disable(sdev->vdac);
>  dac_clk_dis:
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return ret;
>  }
> 
> @@ -333,7 +333,7 @@ static int sdo_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct sdo_device *sdev;
>  	struct resource *res;
> -	int ret = 0;
> +	int ret;

Hmm, this change doesn't look like belonging to this patch.

>  	struct clk *sclk_vpll;
> 
>  	dev_info(dev, "probe start\n");
> @@ -425,8 +425,13 @@ static int sdo_probe(struct platform_device *pdev)
>  	}
> 
>  	/* enable gate for dac clock, because mixer uses it */
> -	clk_enable(sdev->dac);
> -
> +	ret = clk_prepare_enable(sdev->dac);
> +	if (ret < 0) {
> +		dev_err(dev,
> +			"clk_prepare_enable_enable(dac) failed !\n");
> +		ret = PTR_ERR(sdev->dac);

Hmm, ret already contains the error value returned by clk_prepare_enable() 
here, so this looks like a copy paste error.

Best regards,
Tomasz

> +		goto fail_fout_vpll;
> +	}
>  	/* configure power management */
>  	pm_runtime_enable(dev);
> 
> @@ -464,7 +469,7 @@ static int sdo_remove(struct platform_device *pdev)
>  	struct sdo_device *sdev = sd_to_sdev(sd);
> 
>  	pm_runtime_disable(&pdev->dev);
> -	clk_disable(sdev->dac);
> +	clk_disable_unprepare(sdev->dac);
>  	clk_put(sdev->fout_vpll);
>  	clk_put(sdev->dacphy);
>  	clk_put(sdev->dac);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3HZQEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:04:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3HZQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:04:17 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-95-521b7c7f322a
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
Subject: Re: [PATCH RFC 2/5] media: s5p-tv: Fix mixer driver to work with CCF
Date: Mon, 26 Aug 2013 18:03:59 +0200
Message-id: <6152934.i30tL7314f@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1377517114-20222-3-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-3-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd36Gukgg1ez9CzmHznHavGmt4PF
	onfBVTaLs01v2C02Pb7GarGwbQmLxeVdc9gsZpzfx2Rx+zKvxcV18han15xitnjdd5jFYun1
	i0wWTydcZLOYMH0ti8XhFQeYLNa9nA5kvWlntXh1sI3FYv2M1ywW89pfslocm7GE0WLVrj+M
	DuIea+atYfRoae5h81jw+Qq7x+vJExg9ds66y+7xavVMVo871/aweWxeUu9x8N0eJo++LasY
	Pbo/3WL1+LxJzmPj3NAA3igum5TUnMyy1CJ9uwSujP61ixkLjspUtHx/yd7AuE28i5GTQ0LA
	ROLmxA8sELaYxIV769m6GLk4hAQWMUp83nubGcJpYZI4276PEaSKTcBKYmL7KjBbRMBU4t3d
	a2AdzAK7WCTePljBDJIQFvCVODL9P1gRi4CqxNcji8BsXgFNibk/msDWiQq4Spxb9APM5hTw
	l+jbcwBq9WRGiafn/jFBNAhK/Jh8D6yIWUBeYt/+qawQto7E/tZpbBMYBWYhKZuFpGwWkrIF
	jMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj+pn0DsZVDRaHGAU4GJV4eAPYpIOEWBPL
	iitzDzFKcDArifBypAKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2C
	yTJxcEo1MIq61OxRcVs69cWeG6cDo126pAQeisxz2GhVejx6dXHljLRLG+3u5SV9C5z5i3X7
	vl9LfF57c5Y41UZdtsj3XHvE2zOk3pRle+K0m2+KuJKETs7d7Pw3sMfjsudHhr8MG5+/Onyk
	5/5W10bX7VfubfixXjE6X2Cy6m3TuJWfrq1ikKs/cn1LwTIlluKMREMt5qLiRAALd4RB5QIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 26, 2013 01:38:31 PM Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
> Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
> Without it Common Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/mixer_drv.c | 33 +++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
> index 51805a5..f889591 100644
> --- a/drivers/media/platform/s5p-tv/mixer_drv.c
> +++ b/drivers/media/platform/s5p-tv/mixer_drv.c
> @@ -345,21 +345,42 @@ fail:
>  
>  static int mxr_runtime_resume(struct device *dev)
>  {
> +	int ret = 0;

There is no need to initialize it to 0 here.

>  	struct mxr_device *mdev = to_mdev(dev);
>  	struct mxr_resources *res = &mdev->res;
>  
>  	mxr_dbg(mdev, "resume - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks on */
> -	clk_enable(res->mixer);
> -	clk_enable(res->vp);
> -	clk_enable(res->sclk_mixer);
> +	ret = clk_prepare_enable(res->mixer);
> +	if (ret < 0) {
> +		dev_err(dev, "clk_prepare_enable(mixer) failed\n");

There is no consistency in the error messages between patch #1 and #2.

How's about changing error messages in the patch #2 to use

"%s: Failed to prepare and enable mixer clock!", __func__

form?

> +		goto fail;
> +	}
> +	ret = clk_prepare_enable(res->vp);
> +	if (ret < 0) {
> +		dev_err(dev, "clk_prepare_enable(vp) failed\n");
> +		goto fail_mixer;
> +	}
> +	ret = clk_prepare_enable(res->sclk_mixer);
> +	if (ret < 0) {
> +		dev_err(dev, "clk_prepare_enable(sclk_mixer) failed\n");
> +		goto fail_vp;
> +	}
>  	/* apply default configuration */
>  	mxr_reg_reset(mdev);
>  	mxr_dbg(mdev, "resume - finished\n");

While at it the above mxr_dbg() can be moved outside the mutex lock.

>  	mutex_unlock(&mdev->mutex);
>  	return 0;
> +fail_vp:
> +	clk_disable_unprepare(res->vp);
> +fail_mixer:
> +	clk_disable_unprepare(res->mixer);
> +fail:
> +	mutex_unlock(&mdev->mutex);
> +	dev_info(dev, "resume failed\n");

Shouldn't it be dev_err()?

Please also add mxr_dbg(mdev, "resume - finished\n") call here
to match the earlier mxr_dbg(mdev, "resume - start\n") one.

> +	return ret;
>  }
>  
>  static int mxr_runtime_suspend(struct device *dev)
> @@ -369,9 +390,9 @@ static int mxr_runtime_suspend(struct device *dev)
>  	mxr_dbg(mdev, "suspend - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks off */
> -	clk_disable(res->sclk_mixer);
> -	clk_disable(res->vp);
> -	clk_disable(res->mixer);
> +	clk_disable_unprepare(res->sclk_mixer);
> +	clk_disable_unprepare(res->vp);
> +	clk_disable_unprepare(res->mixer);
>  	mutex_unlock(&mdev->mutex);
>  	mxr_dbg(mdev, "suspend - finished\n");
>  	return 0;

While at this driver please note that currently it defines its own macros to
use instead of dev_err(), dev_warn() and dev_info().

drivers/media/platform/s5p-tv/mixer.h:
...
#define mxr_err(mdev, fmt, ...)  dev_err(mdev->dev, fmt, ##__VA_ARGS__)
#define mxr_warn(mdev, fmt, ...) dev_warn(mdev->dev, fmt, ##__VA_ARGS__)
#define mxr_info(mdev, fmt, ...) dev_info(mdev->dev, fmt, ##__VA_ARGS__)
...

Since your patch adds dev_err() and dev_info() instances it would be a good
thing to remove mxr_*() macros in the preparatory patch.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


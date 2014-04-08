Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaDHPwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:52:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37343 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbaDHPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:52:17 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-e3-53441b2f5ae8
Message-id: <53441B2B.1020001@samsung.com>
Date: Tue, 08 Apr 2014 17:52:11 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        a.hajda@samsung.com, kishon@ti.com
Subject: Re: [PATCH 4/4] Revert
 "drm/exynos: add mout_hdmi clock in hdmi driver to change parent"
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
 <1396623201-26000-5-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396623201-26000-5-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e/4NV19aZdgg3mLWCxurTvHatF77iST
	xfwjQNaVr+/ZLCbdn8Bi0bvgKpvFhac9bBZnm96wW2x6fI3V4vKuOWwWM87vY7J4OuEim8Xh
	FQeYLGZMfslmMe/zTiaLee0vWR0EPBZ8vsLusXPWXXaPO9f2sHls//aA1eN+93Emj81L6j36
	tqxi9Dh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZJ+98Zip4IlKxcE07WwPjIsEuRk4OCQET
	iVMv+pghbDGJC/fWs3UxcnEICSxllJg4ZyULhPOZUeL1+zNgVbwCWhJbnk5nArFZBFQllp9f
	ywJiswmoSXxueMQGYvMD1axpug4WFxWIkLjXeJgVoldQ4sfke2BDRQTuMEosbfwEto5Z4A2j
	xJvZH4E2cHAICyRLrH9RDLG5nVGi+Vc/I0g3p4CnxMoNT8GmMgtYS6yctI0RwpaX2LzmLfME
	RsFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghMfhlB+PiY1aHGAU4
	GJV4eCuPOAULsSaWFVfmHmKU4GBWEuH9y+cSLMSbklhZlVqUH19UmpNafIiRiYNTqoGx1Nb0
	jc7rO6lGOY96FgvyXTr/f/9xxn6ZuW8yFBeujlN0W3Y2e1PDr4i/km8zLlqvcjVxs/5XK5ix
	kdWqmvFZ0iqmRie58wt2c7DlXG7syDI8KqK4ZPkKFqdkX48VogtDzj7o8alOv5QZ4LxJk63M
	q+vWzsqDirPyvhocrfnw8+o28611jU+VWIozEg21mIuKEwGA37o5nwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04.04.2014 16:53, Tomasz Stanislawski wrote:
> This reverts commit 59956d35a8618235ea715280b49447bb36f2c975.
>

Probably a reason why this commit is being reverted would be a good idea.

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/gpu/drm/exynos/exynos_hdmi.c |   14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index 9a6d652..8ebb4bf 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -75,7 +75,6 @@ struct hdmi_resources {
>   	struct clk			*sclk_pixel;
>   	struct clk			*sclk_hdmiphy;
>   	struct clk			*hdmiphy;
> -	struct clk			*mout_hdmi;
>   	struct regulator_bulk_data	*regul_bulk;
>   	int				regul_count;
>   };
> @@ -1282,7 +1281,7 @@ static void hdmi_v13_mode_apply(struct hdmi_context *hdata)
>   	}
>
>   	clk_disable_unprepare(hdata->res.sclk_hdmi);
> -	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
> +	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
>   	clk_prepare_enable(hdata->res.sclk_hdmi);
>
>   	/* enable HDMI and timing generator */
> @@ -1449,7 +1448,7 @@ static void hdmi_v14_mode_apply(struct hdmi_context *hdata)
>   	}
>
>   	clk_disable_unprepare(hdata->res.sclk_hdmi);
> -	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
> +	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
>   	clk_prepare_enable(hdata->res.sclk_hdmi);
>
>   	/* enable HDMI and timing generator */
> @@ -1475,7 +1474,7 @@ static void hdmiphy_conf_reset(struct hdmi_context *hdata)
>   	u32 reg;
>
>   	clk_disable_unprepare(hdata->res.sclk_hdmi);
> -	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_pixel);
> +	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_pixel);
>   	clk_prepare_enable(hdata->res.sclk_hdmi);
>
>   	/* operation mode */
> @@ -1982,13 +1981,8 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
>   		DRM_ERROR("failed to get clock 'hdmiphy'\n");
>   		goto fail;
>   	}
> -	res->mout_hdmi = devm_clk_get(dev, "mout_hdmi");
> -	if (IS_ERR(res->mout_hdmi)) {
> -		DRM_ERROR("failed to get clock 'mout_hdmi'\n");
> -		goto fail;
> -	}
>
> -	clk_set_parent(res->mout_hdmi, res->sclk_pixel);
> +	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
>
>   	res->regul_bulk = devm_kzalloc(dev, ARRAY_SIZE(supply) *
>   		sizeof(res->regul_bulk[0]), GFP_KERNEL);
>

Otherwise looks fine and will apply after all its dependencies are 
agreed upon.

Best regards,
Tomasz

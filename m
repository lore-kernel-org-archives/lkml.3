Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaCLOht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:37:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23490 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaCLOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:37:45 -0400
Date: Wed, 12 Mar 2014 15:37:24 +0100
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/4] devfreq: exynos4: Support devicetree to get device id
 of Exynos4 SoC
In-reply-to: <1394624882-2989-2-git-send-email-cw00.choi@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <1794344.yC40yetU2h@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61a-b7fb26d00000724f-37-532071377676
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAV3zQoVggy1XpC2uf3nOanG26Q27
	RfePbIvLu+awWXzuPcJocbtxBZvFmx9nmSwer3jL7sDhsXjPSyaPvi2rGD2O39jO5PF5k1wA
	SxSXTUpqTmZZapG+XQJXxqEvL9kL3glX/Hy/j7mBcaVAFyMnh4SAicSVWbfZIGwxiQv31oPZ
	QgKLGCXe7snoYuQCsluYJA49uscCkmATsJKY2L6KEcQWEdCQmPn3CiNIEbPAHkaJqX2/WEES
	wgLxEqvWPWYHsVkEVCXWXr8JNpVXQFPi4/fNTCC2qICnxI7tK8HinAKuEp/7r7JAbK6X2HH4
	JDtEvaDEj8kQi5kF5CX27Z/KCmHrSOxvncY2gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOMifSe1gXNlgcYhRgINRiYd3gaZ8sBBrYllxZe4hRgkOZiUR3sX5
	CsFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGAUfzuEs
	K1uwdWoS4xOmDx8d+SJNSm3eMnCsDVJVqmhWEti3/N8/vbBY3s28gi9eX1IvCqvxtew6uiHs
	xK1QnSW6zAuZxfM0Ds2TMoif0ps2i0mg3IO75NP/Y4IW3VK+X+xPC76Mt6grcTGOeVY8WdPm
	dOWvC6kmNwt5Tzx5UR/y7Fb3sW1PlViKMxINtZiLihMBsKSyU24CAAA=
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-2-git-send-email-cw00.choi@samsung.com>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Chanwoo,

On Wednesday, March 12, 2014 08:47:59 PM Chanwoo Choi wrote:
> This patch support DT(DeviceTree) method to probe exynos4_bus and get device
> id of each Exynos4 SoC by using dt helper function.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index e07b0c6..168a7c6 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -23,6 +23,7 @@
>  #include <linux/devfreq.h>
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/of.h>
>  #include <linux/module.h>
>  
>  /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
> @@ -1017,6 +1018,28 @@ unlock:
>  	return NOTIFY_DONE;
>  }
>  
> +static struct of_device_id exynos4_busfreq_id_match[] = {
> +	{
> +		.compatible = "samsung,exynos4210-busfreq",
> +		.data = (void *)TYPE_BUSF_EXYNOS4210,
> +	}, {
> +		.compatible = "samsung,exynos4x12-busfreq",
> +		.data = (void *)TYPE_BUSF_EXYNOS4x12,
> +	},
> +};
> +
> +static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	const struct of_device_id *match;
> +
> +	match = of_match_node(exynos4_busfreq_id_match, dev->of_node);
> +	if (!match)
> +		return -ENODEV;
> +
> +	return (int) match->data;
> +}
> +
>  static int exynos4_busfreq_probe(struct platform_device *pdev)
>  {
>  	struct busfreq_data *data;
> @@ -1030,7 +1053,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	data->type = pdev->id_entry->driver_data;
> +	data->type = exynos4_busfreq_get_driver_data(pdev);
>  	data->dmc[0].hw_base = S5P_VA_DMC0;
>  	data->dmc[1].hw_base = S5P_VA_DMC1;
>  	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
> @@ -1135,6 +1158,7 @@ static struct platform_driver exynos4_busfreq_driver = {
>  		.name	= "exynos4-busfreq",
>  		.owner	= THIS_MODULE,
>  		.pm	= &exynos4_busfreq_pm,
> +		.of_match_table = exynos4_busfreq_id_match,
>  	},
>  };

It looks OK but it would be good to also add bindings documentation file,
i.e. Documentation/devicetree/bindings/devfreq/exynos4_bus.txt.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


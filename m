Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3IARAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 13:00:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54139 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569Ab3IARAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 13:00:04 -0400
Message-ID: <5223728E.8000905@ti.com>
Date: Sun, 1 Sep 2013 19:59:58 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130808 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: <dmitry.torokhov@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>, <javier@dowhile0.org>,
        <linux-input@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH 3/3] driver: input: twl6040-vibra: fix missing of_node_put
References: <522190F1.3010103@huawei.com>
In-Reply-To: <522190F1.3010103@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 09:45 AM, Libo Chen wrote:
> 
> decrease twl6040_core_node device_node refcount after task completion
> 
> There are two ways to implement the function of_node_put through
> the marco CONFIG_OF_DYNAMIC, so it is save to call directly.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/input/misc/twl6040-vibra.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
> index 0c2dfc8..f16193a 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -271,12 +271,14 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
>  #endif
> 
>  	if (!pdata && !twl6040_core_node) {
> +		of_node_put(twl6040_core_node);
>  		dev_err(&pdev->dev, "platform_data not available\n");
>  		return -EINVAL;
>  	}
> 
>  	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>  	if (!info) {
> +		of_node_put(twl6040_core_node);
>  		dev_err(&pdev->dev, "couldn't allocate memory\n");
>  		return -ENOMEM;
>  	}
> @@ -304,6 +306,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
>  				     &vddvibl_uV);
>  		of_property_read_u32(twl6040_core_node, "ti,vddvibr-uV",
>  				     &vddvibr_uV);
> +		of_node_put(twl6040_core_node);
>  	}
> 
>  	if ((!info->vibldrv_res && !info->viblmotor_res) ||
> 


-- 
Péter

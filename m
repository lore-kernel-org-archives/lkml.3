Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaGJMes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:34:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6662 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaGJMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:34:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 05:23:52 -0700
Message-ID: <53BE8862.9090908@nvidia.com>
Date: Thu, 10 Jul 2014 15:34:42 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/16] i2c: i2c-tegra: Drop class based scanning to improve
 bootup time
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de> <1404992799-3705-16-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1404992799-3705-16-git-send-email-wsa@the-dreams.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Tested-by: Mikko Perttunen <mperttunen@nvidia.com>

On 10/07/14 14:46, Wolfram Sang wrote:
> This driver has been flagged to drop class based instantiation. The removal
> improves boot-up time and is unneeded for embedded controllers. Users have been
> warned to switch for some time now, so we can actually do the removal. Keep the
> DEPRECATED flag, so the core can inform users that the behaviour finally
> changed now. After another transition period, this flag can go, too.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>   drivers/i2c/busses/i2c-tegra.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index f1bb2fc06791..87d0371cebb7 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -792,7 +792,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>
>   	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
>   	i2c_dev->adapter.owner = THIS_MODULE;
> -	i2c_dev->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
> +	i2c_dev->adapter.class = I2C_CLASS_DEPRECATED;
>   	strlcpy(i2c_dev->adapter.name, "Tegra I2C adapter",
>   		sizeof(i2c_dev->adapter.name));
>   	i2c_dev->adapter.algo = &tegra_i2c_algo;
>

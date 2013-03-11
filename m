Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3CKRQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:16:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51223 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3CKRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:16:06 -0400
Message-ID: <513E1153.20207@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:16:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: akpm@linux-foundation.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] rtc: tegra: use module_platform_driver_probe for
 module init/exit
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com> <1362852588-13362-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362852588-13362-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 11:09 AM, Laxman Dewangan wrote:
> Use macro module_platform_driver_probe() to reduce some of the
> boilerplate code in the driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/rtc/rtc-tegra.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
> index f7718de..4cba10d 100644
> --- a/drivers/rtc/rtc-tegra.c
> +++ b/drivers/rtc/rtc-tegra.c
> @@ -451,17 +451,7 @@ static struct platform_driver tegra_rtc_driver = {
>  	},
>  };
>  
> -static int __init tegra_rtc_init(void)
> -{
> -	return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
> -}
> -module_init(tegra_rtc_init);
> -
> -static void __exit tegra_rtc_exit(void)
> -{
> -	platform_driver_unregister(&tegra_rtc_driver);
> -}
> -module_exit(tegra_rtc_exit);
> +module_platform_driver_probe(tegra_rtc_driver, tegra_rtc_probe);

Out of curiosity here, why not just module_platform_driver(); can't the
instantiation of the RTC device be driven by the presence of the DT
node, and hence the creation of the platform device object, just like
any other driver/device?

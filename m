Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3IWJ6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:58:55 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37164 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab3IWJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:58:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <524010CF.6030605@freescale.com>
Date: Mon, 23 Sep 2013 17:58:39 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <daniel.lezcano@linaro.org>, <linux-pm@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        <patches@linaro.org>
Subject: Re: [PATCH 05/21] cpuidle: make __cpuidle_driver_init() return void
References: <cover.1379779777.git.viresh.kumar@linaro.org> <70ae3eb991bded7c9768ae7934973943c2a1bf05.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <70ae3eb991bded7c9768ae7934973943c2a1bf05.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 09:20 AM, Viresh Kumar wrote:
> __cpuidle_driver_init() doesn't return anything except zero and so doesn't
> really need a return type other than void.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/cpuidle/driver.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 25455e8..8df66c8 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -152,7 +152,7 @@ static void cpuidle_setup_broadcast_timer(void *arg)
>    *
>    * Returns 0 on success, a negative error code otherwise.
If you want to make it return void, you should also update the above 
comment.
>    */
> -static int __cpuidle_driver_init(struct cpuidle_driver *drv)
> +static void __cpuidle_driver_init(struct cpuidle_driver *drv)
>   {
>   	int i;
>   
> @@ -179,8 +179,6 @@ static int __cpuidle_driver_init(struct cpuidle_driver *drv)
>   		drv->bctimer = 1;
>   		break;
>   	}
> -
> -	return 0;
>   }
>   
>   /**
> @@ -206,9 +204,7 @@ static int __cpuidle_register_driver(struct cpuidle_driver *drv)
>   	if (cpuidle_disabled())
>   		return -ENODEV;
>   
> -	ret = __cpuidle_driver_init(drv);
> -	if (ret)
> -		return ret;
> +	__cpuidle_driver_init(drv);
>   
>   	ret = __cpuidle_set_driver(drv);
>   	if (ret)




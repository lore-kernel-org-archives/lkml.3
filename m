Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaJASOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:14:22 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58158 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaJASOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:14:20 -0400
Message-ID: <542C4462.8060704@gmail.com>
Date: Wed, 01 Oct 2014 11:13:54 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Fix build warning for !PM_SLEEP
References: <1412164740-32452-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1412164740-32452-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 04:59 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The dsa_switch_suspend() and dsa_switch_resume() functions are only used
> when PM_SLEEP is enabled, so they need #ifdef CONFIG_PM_SLEEP protection
> to avoid a compiler warning.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Thierry!

> ---
>  net/dsa/dsa.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 6905f2d84c44..22f34cf4cb27 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -238,6 +238,7 @@ static void dsa_switch_destroy(struct dsa_switch *ds)
>  {
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int dsa_switch_suspend(struct dsa_switch *ds)
>  {
>  	int i, ret = 0;
> @@ -280,6 +281,7 @@ static int dsa_switch_resume(struct dsa_switch *ds)
>  
>  	return 0;
>  }
> +#endif
>  
>  
>  /* link polling *************************************************************/
> 


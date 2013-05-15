Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3EOKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:40:50 -0400
Received: from nbd.name ([46.4.11.11]:51228 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3EOKkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:40:49 -0400
Message-ID: <51936516.1080305@openwrt.org>
Date: Wed, 15 May 2013 12:36:06 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl/lantiq: Free mapping configs for both pin and
 groups
References: <1368543638-3299-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1368543638-3299-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/13 17:00, Laurent Pinchart wrote:
> When creating mappings from DT both pin config and group config mappings
> are allocated. Free them both when destroying the mappings.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart+renesas@ideasonboard.com>
Acked-by: John Crispin <blogic@openwrt.org>


> ---
>   drivers/pinctrl/pinctrl-lantiq.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
> index 615c500..d22ca25 100644
> --- a/drivers/pinctrl/pinctrl-lantiq.c
> +++ b/drivers/pinctrl/pinctrl-lantiq.c
> @@ -52,7 +52,8 @@ static void ltq_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
>   	int i;
>
>   	for (i = 0; i<  num_maps; i++)
> -		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
> +		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN ||
> +		    map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
>   			kfree(map[i].data.configs.configs);
>   	kfree(map);
>   }


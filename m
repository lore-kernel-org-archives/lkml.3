Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3HVJBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:01:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55013 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab3HVJBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:01:15 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] pinctrl: rockchip: Simplify for loop iteration
Date: Thu, 22 Aug 2013 11:01:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <1377052130.20078.0.camel@phoenix>
In-Reply-To: <1377052130.20078.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221101.10749.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. August 2013, 04:28:50 schrieb Axel Lin:
> Just return once a match found makes the code simpler and shorter.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

as I'm a bit late for an Ack it seems, I can only offer a thanks for making 
this nicer :-)


Heiko


> ---
>  drivers/pinctrl/pinctrl-rockchip.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index c22457d..64ad0c0 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -167,18 +167,14 @@ static const inline struct rockchip_pin_group
> *pinctrl_name_to_group( const struct rockchip_pinctrl *info,
>  					const char *name)
>  {
> -	const struct rockchip_pin_group *grp = NULL;
>  	int i;
> 
>  	for (i = 0; i < info->ngroups; i++) {
> -		if (strcmp(info->groups[i].name, name))
> -			continue;
> -
> -		grp = &info->groups[i];
> -		break;
> +		if (!strcmp(info->groups[i].name, name))
> +			return &info->groups[i];
>  	}
> 
> -	return grp;
> +	return NULL;
>  }
> 
>  /*
> @@ -204,17 +200,12 @@ static struct rockchip_pin_bank *bank_num_to_bank(
>  	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
>  	int i;
> 
> -	for (i = 0; i < info->ctrl->nr_banks; i++) {
> +	for (i = 0; i < info->ctrl->nr_banks; i++, b++) {
>  		if (b->bank_num == num)
> -			break;
> -
> -		b++;
> +			return b;
>  	}
> 
> -	if (b->bank_num != num)
> -		return ERR_PTR(-EINVAL);
> -
> -	return b;
> +	return ERR_PTR(-EINVAL);
>  }
> 
>  /*


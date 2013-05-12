Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3ELPxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:53:12 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63418 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3ELPxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:53:10 -0400
MIME-Version: 1.0
In-Reply-To: <1368374165-3228-1-git-send-email-laurent.navet@gmail.com>
References: <1368374165-3228-1-git-send-email-laurent.navet@gmail.com>
Date: Sun, 12 May 2013 17:53:09 +0200
Message-ID: <CAH7P7Nj7uD05ZeWaOSZ2tBGF=FJ0YMOKYmnTeoKhfmniKAEQzA@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: ethernet: broadcom: bcm63xx: use devm_ioremap_resource()
From: Laurent Navet <laurent.navet@gmail.com>
To: davem@davemloft.net
Cc: cernekee@gmail.com, jogo@openwrt.org, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Laurent Navet <laurent.navet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, don't take this one

I'll send a more complete one later,
Sorry,

2013/5/12, Laurent Navet <laurent.navet@gmail.com>:
> Replace a call to deprecated devm_request_and_ioremap by
> devm_ioremap_resource.
>
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index 0b3e23e..9de4217 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -1641,9 +1641,9 @@ static int bcm_enet_probe(struct platform_device
> *pdev)
>  	if (ret)
>  		goto out;
>
> -	priv->base = devm_request_and_ioremap(&pdev->dev, res_mem);
> -	if (priv->base == NULL) {
> -		ret = -ENOMEM;
> +	priv->base = devm_ioremap_resource(&pdev->dev, res_mem);
> +	if (IS_ERR(priv->base)) {
> +		ret = PTR_ERR(priv->base);
>  		goto out;
>  	}
>
> --
> 1.7.10.4
>
>


-- 
« On ne résout pas un problème avec les modes de pensée qui l’ont engendré. »
« You cannot solve current problems with current thinking. Current
problems are the result of current thinking »

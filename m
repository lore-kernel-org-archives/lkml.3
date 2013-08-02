Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3HBCCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:02:20 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:24629
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab3HBCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:02:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Fri, 2 Aug 2013 10:06:34 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: pfuze100: Fix off-by-one for max_register
 setting
Message-ID: <20130802020633.GA20542@Robin-OptiPlex-780>
References: <1375358396.15804.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375358396.15804.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 07:59:56PM +0800, Axel Lin wrote:
> max_register should be register count - 1.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Robin,
> I don't have the datasheet, can you check if this patch is correct or not?
> If PFUZE_NUMREGS really means register count, I think this fix is required.
> 
Yes, you are right.
Reviewed-by: Robin Gong <b38343@freescale.com>
Thanks.
> Thanks,
> Axel
>  drivers/regulator/pfuze100-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index bda5561..ba67b2c 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -332,7 +332,7 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
>  static const struct regmap_config pfuze_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
> -	.max_register = PFUZE_NUMREGS,
> +	.max_register = PFUZE_NUMREGS - 1,
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> -- 
> 1.8.1.2
> 
> 
> 
> 


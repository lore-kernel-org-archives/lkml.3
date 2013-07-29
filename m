Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3G2Jqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:46:46 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:16714
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab3G2Jqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:46:45 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 05:46:45 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Mon, 29 Jul 2013 17:35:21 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: pfuze100: Use regulator_map_voltage_ascend
Message-ID: <20130729093519.GB319@Robin-OptiPlex-780>
References: <1375083538.7272.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375083538.7272.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it's reasonable from performance view.
On Mon, Jul 29, 2013 at 03:38:58PM +0800, Axel Lin wrote:
> All table based voltage list have ascendant order.
> Use regulator_map_voltage_ascend for them.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/pfuze100-regulator.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index e9e8ae3..dbb6e1a 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -144,6 +144,7 @@ static struct regulator_ops pfuze100_sw_regulator_ops = {
>  
>  static struct regulator_ops pfuze100_swb_regulator_ops = {
>  	.list_voltage = regulator_list_voltage_table,
> +	.map_voltage = regulator_map_voltage_ascend,
>  	.set_voltage_sel = regulator_set_voltage_sel_regmap,
>  	.get_voltage_sel = regulator_get_voltage_sel_regmap,
>  
> -- 
> 1.8.1.2
> 
> 
> 
> 


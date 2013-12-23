Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3LWIWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:22:34 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:38649
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab3LWIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:22:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 23 Dec 2013 16:24:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <broonie@kernel.org>, <Anson.Huang@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 1/2] regulator: anatop-regulator: Only jump to
 'anatop_probe_end' on error
Message-ID: <20131223082400.GG26070@S2101-09.ap.freescale.net>
References: <1387654046-30997-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387654046-30997-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 05:27:25PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Currently 'anatop_probe_end' path is executed on both succesfull and error paths
> of anatop_regulator_probe().
> 
> To let the code a bit clearer, make 'anatop_probe_end' to be executed only when
> an error happens.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/regulator/anatop-regulator.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> index c734d09..53e6048 100644
> --- a/drivers/regulator/anatop-regulator.c
> +++ b/drivers/regulator/anatop-regulator.c
> @@ -210,9 +210,10 @@ static int anatop_regulator_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, rdev);
>  
> +	return 0;
> +
>  anatop_probe_end:
> -	if (ret)
> -		kfree(sreg->name);
> +	kfree(sreg->name);

While you're there, you may wan to fix the return check of of_get_parent() in
anatop_regulator_probe() as well.

Shawn

>  
>  	return ret;
>  }
> -- 
> 1.8.1.2
> 


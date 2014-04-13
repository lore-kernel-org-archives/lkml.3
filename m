Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaDMIAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 04:00:46 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:13905
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbaDMIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 04:00:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Sun, 13 Apr 2014 16:00:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: imx: replace IS_ERR and PTR_ERR with
 PTR_ERR_OR_ZERO
Message-ID: <20140413080007.GE24180@dragon>
References: <1397205522-24551-1-git-send-email-duanj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1397205522-24551-1-git-send-email-duanj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 04:38:42PM +0800, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>  arch/arm/mach-imx/mach-mx31moboard.c | 5 +----

You are patching a board file under arch/arm/mach-imx, but have the
patch prefixed with "serial:".  This is quite confusing.

You may want to just merge the change into the one you sent to change
mx31moboard-smartbot.c.

Shawn

>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
> index 8f45afe..c05d711 100644
> --- a/arch/arm/mach-imx/mach-mx31moboard.c
> +++ b/arch/arm/mach-imx/mach-mx31moboard.c
> @@ -434,10 +434,7 @@ static int __init moboard_usbh2_init(void)
>  		return -ENODEV;
>  
>  	pdev = imx31_add_mxc_ehci_hs(2, &usbh2_pdata);
> -	if (IS_ERR(pdev))
> -		return PTR_ERR(pdev);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(pdev);
>  }
>  
>  static const struct gpio_led mx31moboard_leds[] __initconst = {
> -- 
> 1.8.3.1
> 
> 
> 


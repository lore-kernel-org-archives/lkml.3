Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3LDONy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:13:54 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:17583
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab3LDONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:13:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z579ehz98dI1432Ib922lzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 4 Dec 2013 21:44:34 +0800
From: Peter Chen <peter.chen@freescale.com>
To: <dt.tangr@gmail.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding
 of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
Message-ID: <20131204134433.GD1573@shlinux1.ap.freescale.net>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 08:20:07PM +1100, dt.tangr@gmail.com wrote:
> From: Daniel Tang <dt.tangr@gmail.com>
> 
> The SoC name was mistakenly used instead of the vendor name in the
> device tree binding for nspire-usb.
> 
> This patch fixes this before the driver becomes widely adopted.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt |    4 ++--
>  drivers/usb/chipidea/ci_hdrc_nspire.c                    |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> index 5ba8e90..ef1fcbf 100644
> --- a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> @@ -1,7 +1,7 @@
>  * TI-Nspire USB OTG Controller
>  
>  Required properties:
> -- compatible: Should be "zevio,nspire-usb"
> +- compatible: Should be "lsi,nspire-usb"

lsi is vendor name, what are zevio and nspire?
Usually, the compatible string should be "vendor_name,soc_name-module_name"

>  - reg: Should contain registers location and length
>  - interrupts: Should contain controller interrupt
>  
> @@ -11,7 +11,7 @@ Recommended properies:
>  Examples:
>  		usb0: usb@B0000000 {
>  			reg = <0xB0000000 0x1000>;
> -			compatible = "zevio,nspire-usb";
> +			compatible = "lsi,nspire-usb";
>  			interrupts = <8>;
>  			vbus-supply = <&vbus_reg>;
>  		};
> diff --git a/drivers/usb/chipidea/ci_hdrc_nspire.c b/drivers/usb/chipidea/ci_hdrc_nspire.c
> index 517ce41..c5c2dde 100644
> --- a/drivers/usb/chipidea/ci_hdrc_nspire.c
> +++ b/drivers/usb/chipidea/ci_hdrc_nspire.c
> @@ -52,7 +52,7 @@ static int ci_hdrc_nspire_remove(struct platform_device *pdev)
>  }
>  
>  static const struct of_device_id ci_hdrc_nspire_dt_ids[] = {
> -	{ .compatible = "zevio,nspire-usb", },
> +	{ .compatible = "lsi,nspire-usb", },
>  	{ /* sentinel */ }
>  };
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen


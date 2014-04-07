Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaDGNrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:47:20 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:59495 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbaDGNrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:47:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 7 Apr 2014 21:46:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH] imx-drm: imx-drm-core: Fix imx_drm_encoder_get_mux_id
Message-ID: <20140407134649.GA3860@dragon>
References: <1396858956-7096-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1396858956-7096-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:22:36AM +0200, Philipp Zabel wrote:
> The decoder mux id is equal to the port id of the encoder's input port
> that is connected to the given crtc, not to the endpoint id (which is
> arbitrary and usually zero).
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

It fixes a color corruption issue on my dual display case (LVDS + HDMI).

Tested-by: Shawn Guo <shawn.guo@freescale.com>

Shawn

> ---
>  drivers/staging/imx-drm/imx-drm-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 4144a75..bc7f8bd 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -517,7 +517,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
>  		of_node_put(port);
>  		if (port == imx_crtc->port) {
>  			ret = of_graph_parse_endpoint(ep, &endpoint);
> -			return ret ? ret : endpoint.id;
> +			return ret ? ret : endpoint.port;
>  		}
>  	} while (ep);
>  
> -- 
> 1.9.1
> 


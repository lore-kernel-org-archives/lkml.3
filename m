Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbaKTJIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:08:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53080 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaKTJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:08:51 -0500
Date: Thu, 20 Nov 2014 10:08:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Johan Hovold <johan@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bruno Thomsen <bth@kamstrup.dk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 08/10] dt/bindings: add clock-select function property to
 micrel phy binding
Message-ID: <20141120090840.GI30369@pengutronix.de>
References: <1416398363-32306-1-git-send-email-johan@kernel.org>
 <1416398363-32306-9-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416398363-32306-9-git-send-email-johan@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:08:06 up 35 days, 20:21, 72 users,  load average: 0.22, 0.16,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 12:59:21PM +0100, Johan Hovold wrote:
> Add "micrel,rmii-reference-clock-select-25-mhz" to Micrel ethernet PHY
> binding documentation.
> 
> This property is needed to properly describe some revisions of Micrel
> PHYs which has the function of this configuration bit inverted so that
> setting it enables 25 MHz rather than 50 MHz clock mode.
> 
> Note that a clock reference ("rmii-ref") is still needed to actually
> select either mode.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/micrel.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
> index 20a6cac7abc6..87496a8c64ab 100644
> --- a/Documentation/devicetree/bindings/net/micrel.txt
> +++ b/Documentation/devicetree/bindings/net/micrel.txt
> @@ -19,6 +19,17 @@ Optional properties:
>  
>  	See the respective PHY datasheet for the mode values.
>  
> + - micrel,rmii-reference-clock-select-25-mhz: RMII Reference Clock Select
> +						bit selects 25 MHz mode
> +
> +	Setting the RMII Reference Clock Select bit enables 25 MHz rather
> +	than 50 MHz clock mode.
> +
> +	Note that this option in only needed for certain PHY revisions with a
> +	non-standard, inverted function of this configuration bit.
> +	Specifically, a clock reference ("rmii-ref" below) is always needed to
> +	actually select a mode.

Nice, that should be clear.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

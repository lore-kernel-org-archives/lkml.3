Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaJNUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:00:39 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38646 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbaJNUAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:00:37 -0400
Date: Tue, 14 Oct 2014 21:59:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] dsa: mv88e6171: Fix tag_protocol check
Message-ID: <20141014195958.GB5331@lunn.ch>
References: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 11:21:04AM -0700, Guenter Roeck wrote:
> tag_protocol is now an enum, so drivers have to check against it.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Andrew Lunn <andrew@lunn.ch>

Thanks for fixing this.

       Andrew

> ---
>  drivers/net/dsa/mv88e6171.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6171.c b/drivers/net/dsa/mv88e6171.c
> index 6365e30..1020a7a 100644
> --- a/drivers/net/dsa/mv88e6171.c
> +++ b/drivers/net/dsa/mv88e6171.c
> @@ -206,7 +206,7 @@ static int mv88e6171_setup_port(struct dsa_switch *ds, int p)
>  	 */
>  	val = 0x0433;
>  	if (dsa_is_cpu_port(ds, p)) {
> -		if (ds->dst->tag_protocol == htons(ETH_P_EDSA))
> +		if (ds->dst->tag_protocol == DSA_TAG_PROTO_EDSA)
>  			val |= 0x3300;
>  		else
>  			val |= 0x0100;
> -- 
> 1.9.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaJNSXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:23:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60830 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbaJNSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:23:17 -0400
Message-ID: <543D6A07.9010300@gmail.com>
Date: Tue, 14 Oct 2014 11:23:03 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] dsa: mv88e6171: Fix tag_protocol check
References: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 11:21 AM, Guenter Roeck wrote:
> tag_protocol is now an enum, so drivers have to check against it.

Good catch, this driver got merged right in the middle of my changes
from __be16 to an enum and this slipped through.

> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Fixes: 42f272539487e49c9ea830ad97db41eb9937d5dc ("net: DSA: Marvell
mv88e6171 switch driver")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>

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
> 


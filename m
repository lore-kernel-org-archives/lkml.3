Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3DASob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:44:31 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38102 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab3DASo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:44:29 -0400
Message-ID: <5159D588.5070603@gmail.com>
Date: Mon, 01 Apr 2013 13:44:24 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] of_net.h: Provide dummy functions if OF_NET is not configured
References: <1364840349-10696-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1364840349-10696-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 01:19 PM, Guenter Roeck wrote:
> of_get_mac_address() and of_get_phy_mode() are only provided if OF_NET
> is configured. While most callers check for the define, not all do, and those
> who do require #ifdef around the code. For those who don't, the missing check
> can result in errors such as

How about removing the ifdef from those callers?

Rob

> 
> arch/powerpc/sysdev/tsi108_dev.c:107:3: error: implicit declaration of
> 	function 'of_get_mac_address' [-Werror=implicit-function-declaration]
> arch/powerpc/sysdev/mv64x60_dev.c:253:2: error: implicit declaration of
> 	function 'of_get_mac_address' [-Werror=implicit-function-declaration]
> 
> Provide dummy function declarations if OF_NET is not configured. This is safe
> because all callers do check the return values. If desired, at least some of
> the #ifdefs in the code can subsequently be removed.
> 
> Cc: David Daney <david.daney@cavium.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  include/linux/of_net.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/of_net.h b/include/linux/of_net.h
> index f474641..61bf53b 100644
> --- a/include/linux/of_net.h
> +++ b/include/linux/of_net.h
> @@ -11,6 +11,16 @@
>  #include <linux/of.h>
>  extern const int of_get_phy_mode(struct device_node *np);
>  extern const void *of_get_mac_address(struct device_node *np);
> +#else
> +static inline const int of_get_phy_mode(struct device_node *np)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline const void *of_get_mac_address(struct device_node *np)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  #endif /* __LINUX_OF_NET_H */
> 


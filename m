Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3LQQd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:33:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34336 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3LQQd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:33:56 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 17 Dec 2013 08:33:47 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: ssb: Remove unused function
 ssb_sdio_func_to_bus() in main.c
Message-ID: <20131217163347.GB737@leaf>
References: <20131217121314.GA27839@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131217121314.GA27839@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:43:14PM +0530, Rashika Kheria wrote:
> Remove unused function ssb_sdio_func_to_bus() in main.c.
> 
> This eliminates the following warning in main.c:
> drivers/ssb/main.c:94:17: warning: no previous prototype for ‘ssb_sdio_func_to_bus’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/ssb/main.c |   19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index 32a811d..8138952 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -90,25 +90,6 @@ found:
>  }
>  #endif /* CONFIG_SSB_PCMCIAHOST */
>  
> -#ifdef CONFIG_SSB_SDIOHOST
> -struct ssb_bus *ssb_sdio_func_to_bus(struct sdio_func *func)
> -{
> -	struct ssb_bus *bus;
> -
> -	ssb_buses_lock();
> -	list_for_each_entry(bus, &buses, list) {
> -		if (bus->bustype == SSB_BUSTYPE_SDIO &&
> -		    bus->host_sdio == func)
> -			goto found;
> -	}
> -	bus = NULL;
> -found:
> -	ssb_buses_unlock();
> -
> -	return bus;
> -}
> -#endif /* CONFIG_SSB_SDIOHOST */
> -
>  int ssb_for_each_bus_call(unsigned long data,
>  			  int (*func)(struct ssb_bus *bus, unsigned long data))
>  {
> -- 
> 1.7.9.5
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaHYUOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:14:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbaHYUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:14:09 -0400
Message-ID: <53FB9910.3020601@infradead.org>
Date: Mon, 25 Aug 2014 13:14:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: Jim Davis <jim.epost@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ariel Elior <ariel.elior@qlogic.com>
Subject: Re: [PATCH] net: bnx2x: fix build error with ptp
References: <53FB9884.8000707@infradead.org>
In-Reply-To: <53FB9884.8000707@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch fixes a build error in linux-next (not in mainline).


On 08/25/14 13:11, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> bnx2x uses ptp functions, so it should select the provider of
> those functions (PTP_1588_CLOCK).  Fixes these build errors:
> 
> drivers/built-in.o: In function `__bnx2x_remove':
> /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13409:
> undefined reference to `ptp_clock_unregister'
> drivers/built-in.o: In function `bnx2x_register_phc':
> /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13202:
> undefined reference to `ptp_clock_register'
> drivers/built-in.o: In function `bnx2x_get_ts_info':
> /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:3498:
> undefined reference to `ptp_clock_index'
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  drivers/net/ethernet/broadcom/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-next-20140825/drivers/net/ethernet/broadcom/Kconfig
> ===================================================================
> --- linux-next-20140825.orig/drivers/net/ethernet/broadcom/Kconfig
> +++ linux-next-20140825/drivers/net/ethernet/broadcom/Kconfig
> @@ -122,6 +122,7 @@ config TIGON3
>  config BNX2X
>  	tristate "Broadcom NetXtremeII 10Gb support"
>  	depends on PCI
> +	select PTP_1588_CLOCK
>  	select FW_LOADER
>  	select ZLIB_INFLATE
>  	select LIBCRC32C
> --


-- 
~Randy

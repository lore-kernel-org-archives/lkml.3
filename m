Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3KVXse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:48:34 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:21113 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3KVXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:48:32 -0500
Message-ID: <1385164109.20467.56.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 2/5] net: MOXA ART: connect to PHY and add ethtool
 support
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 22 Nov 2013 23:48:29 +0000
In-Reply-To: <1385132242-3204-2-git-send-email-jonas.jensen@gmail.com>
References: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
	 <1385132242-3204-2-git-send-email-jonas.jensen@gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20310.005
X-TM-AS-Result: No--12.993000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 15:57 +0100, Jonas Jensen wrote:
> The kernel now has a MDIO bus driver and a phy_driver (RTL8201CP),
> connect to this PHY using OF and add ethtool support.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Applies to next-20131122
> 
>  drivers/net/ethernet/moxa/moxart_ether.c | 179 ++++++++++++++++++++++++++++++-
>  drivers/net/ethernet/moxa/moxart_ether.h |   1 +
>  2 files changed, 179 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
> index 3c14afd..bcc6005 100644
> --- a/drivers/net/ethernet/moxa/moxart_ether.c
> +++ b/drivers/net/ethernet/moxa/moxart_ether.c
> @@ -26,9 +26,15 @@
>  #include <linux/of_irq.h>
>  #include <linux/crc32.h>
>  #include <linux/crc32c.h>
> +#include <linux/phy.h>
> +#include <linux/of_mdio.h>
>  
>  #include "moxart_ether.h"
>  
> +#define DRV_NAME                "moxart-ethernet"
> +#define DRV_VERSION             "0.2"
> +#define MOXART_NUM_STATS        16

MOXART_NUM_STATS should be defined as ARRAY_SIZE(ethtool_stats_keys).

[...]
> +static void moxart_get_drvinfo(struct net_device *ndev,
> +			       struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
> +	strlcpy(info->bus_info, dev_name(&ndev->dev), sizeof(info->bus_info));
> +	info->n_stats = MOXART_NUM_STATS;
[...]

Don't initialise n_stats here; the core will initialise it using your
get_sset_count implementation.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


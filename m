Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3GONyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:54:25 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:53737 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3GONyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:54:23 -0400
Message-ID: <1373896458.3745.7.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] ethtool: fixed trailing statements in ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: Dragos Foianu <dragos.foianu@gmail.com>
CC: <davem@davemloft.net>, <ben@decadent.org.uk>, <pshelar@nicira.com>,
        <mschmidt@redhat.com>, <ebiederm@xmission.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 15 Jul 2013 14:54:18 +0100
In-Reply-To: <1373722980-19704-1-git-send-email-dragos.foianu@gmail.com>
References: <1373722980-19704-1-git-send-email-dragos.foianu@gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20016.005
X-TM-AS-Result: No--10.363200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 14:43 +0100, Dragos Foianu wrote:
> Applied fixes suggested by checkpatch.pl.
> 
> Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>

I think that it's fine to put the conditional statement on the same line
for repetitive conversion code like this.  I don't think anyone's likely
to mis-read it, which I think is the reason why checkpatch warns.

But I also won't object to this.  I don't mind either way.

Ben.

> ---
>  net/core/ethtool.c |   30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index ab5fa63..78e9d92 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -279,11 +279,16 @@ static u32 __ethtool_get_flags(struct net_device *dev)
>  {
>  	u32 flags = 0;
>  
> -	if (dev->features & NETIF_F_LRO)	     flags |= ETH_FLAG_LRO;
> -	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX) flags |= ETH_FLAG_RXVLAN;
> -	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX) flags |= ETH_FLAG_TXVLAN;
> -	if (dev->features & NETIF_F_NTUPLE)	     flags |= ETH_FLAG_NTUPLE;
> -	if (dev->features & NETIF_F_RXHASH)	     flags |= ETH_FLAG_RXHASH;
> +	if (dev->features & NETIF_F_LRO)
> +		flags |= ETH_FLAG_LRO;
> +	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
> +		flags |= ETH_FLAG_RXVLAN;
> +	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
> +		flags |= ETH_FLAG_TXVLAN;
> +	if (dev->features & NETIF_F_NTUPLE)
> +		flags |= ETH_FLAG_NTUPLE;
> +	if (dev->features & NETIF_F_RXHASH)
> +		flags |= ETH_FLAG_RXHASH;
>  
>  	return flags;
>  }
> @@ -295,11 +300,16 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
>  	if (data & ~ETH_ALL_FLAGS)
>  		return -EINVAL;
>  
> -	if (data & ETH_FLAG_LRO)	features |= NETIF_F_LRO;
> -	if (data & ETH_FLAG_RXVLAN)	features |= NETIF_F_HW_VLAN_CTAG_RX;
> -	if (data & ETH_FLAG_TXVLAN)	features |= NETIF_F_HW_VLAN_CTAG_TX;
> -	if (data & ETH_FLAG_NTUPLE)	features |= NETIF_F_NTUPLE;
> -	if (data & ETH_FLAG_RXHASH)	features |= NETIF_F_RXHASH;
> +	if (data & ETH_FLAG_LRO)
> +		features |= NETIF_F_LRO;
> +	if (data & ETH_FLAG_RXVLAN)
> +		features |= NETIF_F_HW_VLAN_CTAG_RX;
> +	if (data & ETH_FLAG_TXVLAN)
> +		features |= NETIF_F_HW_VLAN_CTAG_TX;
> +	if (data & ETH_FLAG_NTUPLE)
> +		features |= NETIF_F_NTUPLE;
> +	if (data & ETH_FLAG_RXHASH)
> +		features |= NETIF_F_RXHASH;
>  
>  	/* allow changing only bits set in hw_features */
>  	changed = (features ^ dev->features) & ETH_ALL_FEATURES;

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


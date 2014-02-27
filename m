Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaB0Rav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:30:51 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16891 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaB0Rat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:30:49 -0500
X-IronPort-AV: E=Sophos;i="4.97,556,1389772800"; 
   d="scan'208";a="16710316"
Message-ID: <530F762E.6030301@broadcom.com>
Date: Thu, 27 Feb 2014 18:30:22 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] brcmfmac: set NET_NAME_USER for P2P ifs
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com> <1393512434-1325-5-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1393512434-1325-5-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 03:47 PM, David Herrmann wrote:
> Netdevs created via nl80211 (currently only P2P ifs) have names provided
> by user-space. Therefore, set the naming-policy to NET_NAME_USER so it is
> correctly shown in sysfs.
> 
- Cc: Arend van Spriel <arend@broadcom.com>
+ Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> index fc4f98b..6af4d26 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> @@ -2310,6 +2310,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
>  		goto fail;
>  	}
>  
> +	ifp->ndev->name_assign_type = NET_NAME_USER;
>  	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
>  	err = brcmf_net_attach(ifp, true);
>  	if (err) {
> 


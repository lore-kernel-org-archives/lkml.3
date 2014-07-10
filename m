Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaGJUIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:08:23 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:17180 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaGJUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:08:22 -0400
X-IronPort-AV: E=Sophos;i="5.01,639,1400050800"; 
   d="scan'208";a="38906501"
Message-ID: <53BEF2A6.6050103@broadcom.com>
Date: Thu, 10 Jul 2014 22:08:06 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        John Linville <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH v7 29/33] net: brcmfmac - set name assign type
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-30-git-send-email-teg@jklm.no>
In-Reply-To: <1404980258-30853-30-git-send-email-teg@jklm.no>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-07-14 10:17, Tom Gundersen wrote:
> The name is given by the firmware, so we assume it is predictable.

How about the scenario where one would have multiple broadcom wifi
devices in the system. Both driver instances would alloc_netdev with
predictable but also the same ifname. Wondering whether we should ignore
the firmware ifname altogether.

Regards,
Arend

> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: John Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list@broadcom.com
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> index f6990f2..8d32721 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> @@ -201,7 +201,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
>  		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
>  			  emsg->addr);
>  		ifp = brcmf_add_if(drvr, ifevent->bssidx, ifevent->ifidx,
> -				   emsg->ifname, NET_NAME_UNKNOWN, emsg->addr);
> +				   emsg->ifname, NET_NAME_PREDICTABLE,
> +				   emsg->addr);
>  		if (IS_ERR(ifp))
>  			return;
>  		brcmf_fws_add_interface(ifp);
> 


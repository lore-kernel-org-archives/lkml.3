Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3CDNhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:37:31 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1457 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab3CDNh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:37:29 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5134A37D.9000704@broadcom.com>
Date: Mon, 4 Mar 2013 14:37:01 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Akinobu Mita" <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        "Michael Chan" <mchan@broadcom.com>,
        "Thomas Sailer" <t.sailer@alumni.ethz.ch>,
        "Jean-Paul Roubelat" <jpr@f6fbb.org>, "Bing Zhao" <bzhao@marvell.com>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH -v3 16/23] drivers/net: rename random32() to
 prandom_u32()
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
 <1362401911-14074-17-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1362401911-14074-17-git-send-email-akinobu.mita@gmail.com>
X-WSS-ID: 7D2A7C8E23C6875220-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/13 13:58, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>
> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Acked-by: Thomas Sailer<t.sailer@alumni.ethz.ch>
> Acked-by: Bing Zhao<bzhao@marvell.com>  [mwifiex]
> Cc: "David S. Miller"<davem@davemloft.net>
> Cc: Michael Chan<mchan@broadcom.com>
> Cc: Thomas Sailer<t.sailer@alumni.ethz.ch>
> Cc: Jean-Paul Roubelat<jpr@f6fbb.org>
> Cc: Bing Zhao<bzhao@marvell.com>
> Cc: Brett Rudley<brudley@broadcom.com>
> Cc: Arend van Spriel<arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin"<frankyl@broadcom.com>
> Cc: Hante Meuleman<meuleman@broadcom.com>
> Cc: brcm80211-dev-list@broadcom.com
> Cc: netdev@vger.kernel.org
> Cc: linux-hams@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> ---
> * Changes from v2
> - add Acked-by: line
> - add rename for brcm80211
>
>   drivers/net/ethernet/broadcom/cnic.c          | 4 ++--
>   drivers/net/hamradio/baycom_epp.c             | 2 +-
>   drivers/net/hamradio/hdlcdrv.c                | 2 +-
>   drivers/net/hamradio/yam.c                    | 2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 2 +-
>   drivers/net/wireless/mwifiex/cfg80211.c       | 4 ++--
>   6 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> index 4166e64..bca31a8 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
> @@ -1118,7 +1118,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
>   	if (afx_hdl->is_listen&&  afx_hdl->my_listen_chan)
>   		/* 100ms ~ 300ms */
>   		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
> -						100 * (1 + (random32() % 3)));
> +					100 * (1 + (prandom_u32() % 3)));

Seems like indentation is wrong now. Please retain the alignment.

Regards,
Arend


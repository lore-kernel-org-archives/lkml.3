Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3GATeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:34:21 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33176 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab3GATeT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:34:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avinash Patil <patila@marvell.com>, Stone Piao <piaoyun@marvell.com>
Date: Mon, 1 Jul 2013 12:34:05 -0700
Subject: RE: [PATCH 1/1] mwifiex: add tx info to skb when forming mgmt frame
Thread-Topic: [PATCH 1/1] mwifiex: add tx info to skb when forming mgmt frame
Thread-Index: Ac52PiJAz7Sf571bQQWN0V5vYx79FQAUutEw
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2CE60BC@SC-VEXCH1.marvell.com>
References: <1372671230-8733-1-git-send-email-harvey.huawei.yang@gmail.com>
In-Reply-To: <1372671230-8733-1-git-send-email-harvey.huawei.yang@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Thanks for your patch.

> From: Huawei Yang <harvey.huawei.yang@gmail.com>
> 
> In function 'mwifiex_write_data_complete' it need tx info to find the mwifiex_private to updates
> statistics and wake up tx queues. Or we may trigger tx queues timeout when transmitting lots of mgmt
> frames burstly.

Please shorten the commit log to less than 68 characters per line.

> 
> Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index e42b266..e8655f9 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -166,6 +166,10 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
>  	memcpy(skb_put(skb, len - sizeof(struct ieee80211_hdr_3addr)),
>  	       buf + sizeof(struct ieee80211_hdr_3addr),
>  	       len - sizeof(struct ieee80211_hdr_3addr));
> +
> +	tx_info = MWIFIEX_SKB_TXCB(skb);
> +	tx_info->bss_num = priv->bss_num;
> +	tx_info->bss_type = priv->bss_type;

This code doesn't compile because both tx_info and priv are undefined in this function.
Perhaps you meant to add it in mwifiex_cfg80211_mgmt_tx() instead?

@@ -216,6 +216,10 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wirele
                return -ENOMEM;
        }

+       tx_info = MWIFIEX_SKB_TXCB(skb);
+       tx_info->bss_num = priv->bss_num;
+       tx_info->bss_type = priv->bss_type;
+
        mwifiex_form_mgmt_frame(skb, buf, len);
        mwifiex_queue_tx_pkt(priv, skb);

> 
>  	skb->priority = LOW_PRIO_TID;
>  	do_gettimeofday(&tv);

Thanks,
Bing

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3GBFhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:37:48 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:56412 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab3GBFhq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:37:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Harvey Yang <harvey.huawei.yang@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Jul 2013 22:33:13 -0700
Subject: RE: [PATCH V2 1/1] mwifiex: add tx info to skb when forming mgmt
 frame
Thread-Topic: [PATCH V2 1/1] mwifiex: add tx info to skb when forming mgmt
 frame
Thread-Index: Ac52yoPPGnwaeGtMQXe7d7QirRFfjAAF97dQ
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2E061D9@SC-VEXCH1.marvell.com>
References: <1372731526-2979-1-git-send-email-harvey.huawei.yang@gmail.com>
In-Reply-To: <1372731526-2979-1-git-send-email-harvey.huawei.yang@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

> From: Huawei Yang <harvey.huawei.yang@gmail.com>
> 
> In function 'mwifiex_write_data_complete' it need tx info to find the
> mwifiex_private to updates statistics and wake up tx queues.
> Or we may trigger tx queues timeout when transmitting lots of mgmt frames.
> 
> Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c
> b/drivers/net/wireless/mwifiex/cfg80211.c
> index e42b266..b4e2538 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -186,6 +186,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy,
> struct wireless_dev *wdev,
>  	struct sk_buff *skb;
>  	u16 pkt_len;
>  	const struct ieee80211_mgmt *mgmt;
> +	struct mwifiex_txinfo *tx_info;
>  	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev-
> >netdev);
> 
>  	if (!buf || !len) {
> @@ -212,6 +213,10 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy,
> struct wireless_dev *wdev,
>  		wiphy_err(wiphy, "allocate skb failed for management
> frame\n");
>  		return -ENOMEM;
>  	}
> +

Here checkpatch.pl script reports whitespace damaged error.
I can fix it in my local tree and resend v3 to John after the 3.11 merge window.

Thanks,
Bing

> +	tx_info = MWIFIEX_SKB_TXCB(skb);
> +	tx_info->bss_num = priv->bss_num;
> +	tx_info->bss_type = priv->bss_type;
> 
>  	mwifiex_form_mgmt_frame(skb, buf, len);
>  	mwifiex_queue_tx_pkt(priv, skb);
> --
> 1.7.10.4


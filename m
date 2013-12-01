Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3LAJfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:35:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:34151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3LAJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:35:35 -0500
Message-ID: <1385890523.4171.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Sun, 01 Dec 2013 10:35:23 +0100
In-Reply-To: <1385843940.2664.4.camel@joe-AO722>
References: <528AEFB7.4060301@gmail.com>
	 <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>
	 <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
	 <52957ADA.2080704@gmail.com>
	 (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>
	 <5299D306.7070701@gmail.com>
	 (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>
	 <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>
	 (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>
	 <1385843940.2664.4.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-30 at 12:39 -0800, Joe Perches wrote:

> +++ b/net/mac80211/tx.c
> @@ -1777,18 +1777,16 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		}
>  		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
>  					u.ap);
> -		chanctx_conf = rcu_dereference(ap_sdata->vif.chanctx_conf);
> -		if (!chanctx_conf)
> -			goto fail_rcu;
> -		band = chanctx_conf->def.chan->band;
> -		if (sta)
> -			break;
>  		/* fall through */
>  	case NL80211_IFTYPE_AP:
> -		if (sdata->vif.type == NL80211_IFTYPE_AP)
> -			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +		chanctx_conf = rcu_dereference(ap_sdata->vif.chanctx_conf);

Good try, but no, now ap_sdata isn't even assigned. :)

johannes


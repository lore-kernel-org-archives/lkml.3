Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3BFR63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:58:29 -0500
Received: from mail.candelatech.com ([208.74.158.172]:53925 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3BFR62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:58:28 -0500
Message-ID: <511299BA.905@candelatech.com>
Date: Wed, 06 Feb 2013 09:58:18 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211/cfg.c: fix error using of sizeof()
References: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 08:23 AM, Cong Ding wrote:
> Using 'sizeof' on array given as function argument returns size of a pointer
> rather than the size of array.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>   net/mac80211/cfg.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 661b878..af561d5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2058,7 +2058,8 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
>   {
>   	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>
> -	memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
> +	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
> +			sizeof(int) * IEEE80211_NUM_BANDS);

Should it perhaps be:  sizeof(*rate) * IEEE80211_NUM_BANDS
just in case the type ever changes?

Thanks,
Ben

>
>   	return 0;
>   }
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


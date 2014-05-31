Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEaPSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:18:11 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:56748 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaEaPSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:18:09 -0400
Message-ID: <5389F2A0.1000903@bfs.de>
Date: Sat, 31 May 2014 17:17:52 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Solomon Peachy <pizza@shaftnet.org>, kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/11] cw1200: Remove useless return variables
References: <1401542051-3174-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1401542051-3174-2-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 31.05.2014 15:14, schrieb Peter Senna Tschudin:
> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
> 
> The coccinelle script that find and fixes this issue is:
> // <smpl>
> @@
> type T;
> constant C;
> identifier ret;
> @@
> - T ret = C;
> ... when != ret
>     when strict
> return
> - ret
> + C
> ;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/net/wireless/cw1200/sta.c |   19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
> index cd0cad7..622370c 100644
> --- a/drivers/net/wireless/cw1200/sta.c
> +++ b/drivers/net/wireless/cw1200/sta.c
> @@ -2289,24 +2289,7 @@ static int cw1200_upload_null(struct cw1200_common *priv)
>  
>  static int cw1200_upload_qosnull(struct cw1200_common *priv)
>  {
> -	int ret = 0;
> -	/* TODO:  This needs to be implemented
> -
> -	struct wsm_template_frame frame = {
> -		.frame_type = WSM_FRAME_TYPE_QOS_NULL,
> -		.rate = 0xFF,
> -	};
> -
> -	frame.skb = ieee80211_qosnullfunc_get(priv->hw, priv->vif);
> -	if (!frame.skb)
> -		return -ENOMEM;
> -
> -	ret = wsm_set_template_frame(priv, &frame);
> -
> -	dev_kfree_skb(frame.skb);
> -
> -	*/
> -	return ret;
> +	return 0;
>  }
>  
>  static int cw1200_enable_beaconing(struct cw1200_common *priv,


are you sure you want to remove the entire function ?

re,
 wh

> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaHRT3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:29:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46528 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaHRT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:29:41 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] carl9170: Replace rcu_dereference() with rcu_access_pointer()
Date: Mon, 18 Aug 2014 21:29:36 +0200
Message-ID: <3029076.uaUkTd8nru@debian64>
User-Agent: KMail/4.13.3 (Linux/3.16.0-wl+; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140817104806.GA14533@ada>
References: <20140817104806.GA14533@ada>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2014 01:48:07 PM Andreea-Cristina Bernat wrote:
> The rcu_dereference() call is used directly in a condition.
> Since its return value is never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacement.
> [...]
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  drivers/net/wireless/ath/carl9170/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index f8ded84..12018ff 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1431,7 +1431,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
>  			return -EOPNOTSUPP;
>  
>  		rcu_read_lock();
> -		if (rcu_dereference(sta_info->agg[tid])) {
> +		if (rcu_access_pointer(sta_info->agg[tid])) {
>  			rcu_read_unlock();
>  			return -EBUSY;
>  		}

There's more. The check does not do a whole lot. I think *it* [the check] and the
rcu_read_[un]lock [and the return -EBUSY] can be removed completely from the
IEEE80211_AMPDU_TX_START code-path in carl9170_op_ampdu_action.

It would be awesome, if you could you make a patch which removes this 
unneeded cosmic-ray-protection check :-) .

Thanks
Christian

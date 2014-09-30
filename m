Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaI3LC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:02:56 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39425 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaI3LCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:02:55 -0400
Date: Tue, 30 Sep 2014 13:02:48 +0200
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michalis Pappas <mpappas@fastmail.fm>,
        Davide Gianforte <davide@gengisdave.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: gdm72xx: fix coding style
Message-ID: <20140930110248.GA10662@L80496>
References: <1412015484.4302.51.camel@joe-AO725>
 <1412072592-8682-1-git-send-email-thibaut.robert@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412072592-8682-1-git-send-email-thibaut.robert@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 30 Sep 2014 à 12:23:12 (+0200), Thibaut Robert a écrit :
> Remove unnecessary else after return.
> Follow coding style for curly braces around single statements.
> Fix a typo in error message.
> 
> Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
> ---
>  drivers/staging/gdm72xx/netlink_k.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> index 9bf00e6..31862e5 100644
> --- a/drivers/staging/gdm72xx/netlink_k.c
> +++ b/drivers/staging/gdm72xx/netlink_k.c
> @@ -71,10 +71,11 @@ static void netlink_rcv_cb(struct sk_buff *skb)
>  			if (dev) {
>  				rcv_cb(dev, nlh->nlmsg_type, msg, mlen);
>  				dev_put(dev);
> -			} else
> +			} else {
>  				netdev_err(skb->dev,
>  					   "dev_get_by_index(%d) is not found.\n",
>  					   ifindex);
> +			}
>  		} else {
>  			netdev_err(skb->dev, "Unregistered Callback\n");
>  		}
> @@ -120,9 +121,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
>  	struct nlmsghdr *nlh;
>  	int ret = 0;
>  
> -	if (group > ND_MAX_GROUP) {
> -		pr_err("Group %d is invalied.\n", group);
> -		pr_err("Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
> +	if (group < 0 || group > ND_MAX_GROUP) {
> +		pr_err("Invalid group %d (valid groups are 0 to %d)\n",
> +			group, ND_MAX_GROUP);
>  		return -EINVAL;
>  	}
>  
> @@ -145,14 +146,11 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
>  
>  	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
>  
> -	if (!ret) {
> +	if (!ret)
>  		return len;
> -	} else {
> -		if (ret != -ESRCH) {
> -			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> -			       group, type, len, ret);
> -		}
> -		ret = 0;
> -	}
> -	return ret;
> +
> +	if (ret != -ESRCH)
> +		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> +		       group, type, len, ret);
> +	return 0;
>  }
> -- 
> 1.9.1
> 
I've just seen that some identical changes have already been pushed in the meanwhile, the previous patch does not apply. An new patch will follow (mainly for the typo correction)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJEBSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 21:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJEBSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 21:18:24 -0400
Date: Sat, 4 Oct 2014 18:18:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Davide Gianforte <davide@gengisdave.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: fix typo and coding style
Message-ID: <20141005011823.GA11675@kroah.com>
References: <1412015484.4302.51.camel@joe-AO725>
 <1412074983-10909-1-git-send-email-thibaut.robert@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412074983-10909-1-git-send-email-thibaut.robert@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 01:03:03PM +0200, Thibaut Robert wrote:
> Fix a typo in error message.
> Add missing curling braces to conform to coding style.
> Improve readibility.

That's three things in one patch :(

Please only do one thing per patch.

> 
> Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
> ---
>  drivers/staging/gdm72xx/netlink_k.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> index 9d78bfc..31862e5 100644
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

How can group be less than 0?

thanks,

greg k-h

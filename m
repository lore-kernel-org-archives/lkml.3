Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaI3KUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:20:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36259 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaI3KUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:20:12 -0400
Date: Tue, 30 Sep 2014 12:20:04 +0200
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michalis Pappas <mpappas@fastmail.fm>,
        Davide Gianforte <davide@gengisdave.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: gdm72xx: fix coding style
Message-ID: <20140930102004.GC6459@L80496>
References: <1412014535-24239-1-git-send-email-thibaut.robert@gmail.com>
 <1412015484.4302.51.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412015484.4302.51.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 29 Sep 2014 à 11:31:24 (-0700), Joe Perches a écrit :
> On Mon, 2014-09-29 at 20:15 +0200, Thibaut Robert wrote:
> > This patch remove a checkstyle warning in netlink_k.c.
> > Note: This is my homework of the day.
> 
> The "Note: " line isn't useful for a commit message.
> Neither is the checkpatch warning bit.
> 
> Maybe the commit message could be something like:
> "Remove unnecessary else after return".
> 
> > diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> []
> > @@ -147,12 +147,11 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
> >  
> >  	if (!ret) {
> >  		return len;
> > -	} else {
> > -		if (ret != -ESRCH) {
> > -			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> > -			       group, type, len, ret);
> > -		}
> > -		ret = 0;
> >  	}
> > -	return ret;
> > +
> > +	if (ret != -ESRCH) {
> > +		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> > +		       group, type, len, ret);
> > +	}
> 
> OK, but you don't need the braces around the pr_err.
> 
> My preference is to also fix the typo in the function
> and would be something like:
> ---
>  drivers/staging/gdm72xx/netlink_k.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> index 9bf00e6..43d2a49 100644
> --- a/drivers/staging/gdm72xx/netlink_k.c
> +++ b/drivers/staging/gdm72xx/netlink_k.c
> @@ -120,9 +120,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
>  	struct nlmsghdr *nlh;
>  	int ret = 0;
>  
> -	if (group > ND_MAX_GROUP) {
> -		pr_err("Group %d is invalied.\n", group);
> -		pr_err("Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
> +	if (group < 0 || group > ND_MAX_GROUP) {
> +		pr_err("Invalid group %d (valid groups are 0 to %d)\n",
> +		       group, ND_MAX_GROUP);
>  		return -EINVAL;
>  	}
>  
> @@ -144,15 +144,12 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
>  	NETLINK_CB(skb).dst_group = 0;
>  
>  	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
> -
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
> +
> +	return 0;
>  }
> 
> 
> 
Thanks for this newbie friendly attitude. That's much appreciated. An updated patch will follow.

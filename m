Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3C1OhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:37:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:34994 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3C1OhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:37:10 -0400
Date: Thu, 28 Mar 2013 14:37:09 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 4/6] gdm72xx: replace obsolete NLMSG_* with type safe
 nlmsg_*
Message-ID: <20130328143709.GE23043@casper.infradead.org>
References: <1364403137-32806-1-git-send-email-honkiko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364403137-32806-1-git-send-email-honkiko@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/13 at 12:52am, Hong Zhiguo wrote:
> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
> ---
>  drivers/staging/gdm72xx/netlink_k.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> index 52c25ba..c1239aa 100644
> --- a/drivers/staging/gdm72xx/netlink_k.c
> +++ b/drivers/staging/gdm72xx/netlink_k.c
> @@ -25,12 +25,12 @@
>  
>  #define ND_MAX_GROUP			30
>  #define ND_IFINDEX_LEN			sizeof(int)
> -#define ND_NLMSG_SPACE(len)		(NLMSG_SPACE(len) + ND_IFINDEX_LEN)
> +#define ND_NLMSG_SPACE(len)		(nlmsg_total_size(len) + ND_IFINDEX_LEN)
>  #define ND_NLMSG_DATA(nlh) \
> -	((void *)((char *)NLMSG_DATA(nlh) + ND_IFINDEX_LEN))
> +	((void *)((char *)nlmsg_data(nlh) + ND_IFINDEX_LEN))
>  #define ND_NLMSG_S_LEN(len)		(len+ND_IFINDEX_LEN)
>  #define ND_NLMSG_R_LEN(nlh)		(nlh->nlmsg_len-ND_IFINDEX_LEN)
> -#define ND_NLMSG_IFIDX(nlh)		NLMSG_DATA(nlh)
> +#define ND_NLMSG_IFIDX(nlh)		nlmsg_data(nlh)
>  #define ND_MAX_MSG_LEN			8096

This is not pretty at all but outside of the context of your patch.

Acked-by: Thomas Graf <tgraf@suug.ch>

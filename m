Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3C2C5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:57:48 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45224 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3C2C5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:57:47 -0400
Message-ID: <51550325.6040000@hp.com>
Date: Thu, 28 Mar 2013 22:57:41 -0400
From: Brian Haley <brian.haley@hp.com>
Organization: HP Cloud Services
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hong Zhiguo <honkiko@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, tgraf@suug.ch
Subject: Re: [PATCH 1/6] net-next: replace obsolete NLMSG_* with type safe
 nlmsg_*
References: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
In-Reply-To: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 12:47 PM, Hong Zhiguo wrote:
> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>

> diff --git a/net/ieee802154/netlink.c b/net/ieee802154/netlink.c
> index 97351e1..9247252 100644
> --- a/net/ieee802154/netlink.c
> +++ b/net/ieee802154/netlink.c
> @@ -65,7 +65,7 @@ struct sk_buff *ieee802154_nl_create(int flags, u8 req)
>  int ieee802154_nl_mcast(struct sk_buff *msg, unsigned int group)
>  {
>  	/* XXX: nlh is right at the start of msg */
> -	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
> +	void *hdr = genlmsg_data(nlmsg_data(msg->data));
>  
>  	if (genlmsg_end(msg, hdr) < 0)
>  		goto out;
> @@ -98,7 +98,7 @@ struct sk_buff *ieee802154_nl_new_reply(struct genl_info *info,
>  int ieee802154_nl_reply(struct sk_buff *msg, struct genl_info *info)
>  {
>  	/* XXX: nlh is right at the start of msg */
> -	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
> +	void *hdr = genlmsg_data(nlmsg_data(msg->data));
>  
>  	if (genlmsg_end(msg, hdr) < 0)
>  		goto out;

  CC [M]  net/ieee802154/netlink.o
net/ieee802154/netlink.c: In function ‘ieee802154_nl_mcast’:
net/ieee802154/netlink.c:68: warning: passing argument 1 of ‘nlmsg_data’ from
incompatible pointer type
include/net/netlink.h:302: note: expected ‘const struct nlmsghdr *’ but argument
is of type ‘unsigned char *’
net/ieee802154/netlink.c: In function ‘ieee802154_nl_reply’:
net/ieee802154/netlink.c:101: warning: passing argument 1 of ‘nlmsg_data’ from
incompatible pointer type
include/net/netlink.h:302: note: expected ‘const struct nlmsghdr *’ but argument
is of type ‘unsigned char *’

-Brian

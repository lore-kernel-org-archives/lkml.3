Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaGKTXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:23:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56787 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaGKTXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:23:35 -0400
Date: Fri, 11 Jul 2014 12:23:35 -0700 (PDT)
Message-Id: <20140711.122335.833933211386013460.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dh.herrmann@gmail.com, kay@vrfy.org
Subject: Re: [PATCH v8 4/4] net: rtnetlink - make create_link take
 name_assign_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405026066-2547-5-git-send-email-teg@jklm.no>
References: <1405026066-2547-1-git-send-email-teg@jklm.no>
	<1405026066-2547-5-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Jul 2014 12:23:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 23:01:06 +0200

> This passes down NET_NAME_USER (or NET_NAME_ENUM) to alloc_netdev(),
> for any device created over rtnetlink.
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> ---
>  drivers/net/veth.c      | 11 ++++++++---
>  include/net/rtnetlink.h |  1 +
>  net/core/rtnetlink.c    | 12 ++++++++----
>  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b4a10bc..5058700 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -319,6 +319,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
>  	struct nlattr *peer_tb[IFLA_MAX + 1], **tbp;
>  	struct ifinfomsg *ifmp;
>  	struct net *net;
> +	unsigned char name_assign_type;
>  
>  	/*
>  	 * create and register peer first

Please order local variables in reverse-christmas-tree order, in this case
name_assign_type should be placed on the line before the declaration for
"ifmp".

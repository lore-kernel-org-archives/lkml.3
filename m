Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbaGQXUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:20:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbaGQXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:20:40 -0400
Date: Thu, 17 Jul 2014 16:20:40 -0700 (PDT)
Message-Id: <20140717.162040.171795478640839195.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v9 4/9] net: set name_assign_type when setting
 names via ioctls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405584370-30054-5-git-send-email-teg@jklm.no>
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
	<1405584370-30054-5-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Jul 2014 16:20:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Thu, 17 Jul 2014 10:06:05 +0200

> @@ -2787,10 +2788,13 @@ static int gsm_create_network(struct gsm_dlci *dlci, struct gsm_netconfig *nc)
>  	pr_debug("create network interface");
>  
>  	netname = "gsm%d";
> -	if (nc->if_name[0] != '\0')
> +	if (nc->if_name[0] != '\0') {
>  		netname = nc->if_name;
> -	net = alloc_netdev(sizeof(struct gsm_mux_net), netname,
> -			   NET_NAME_UNKNOWN, gsm_mux_net_init);
> +		name_assign_type = NET_NAME_USER;
> +	}
> +	net = alloc_netdev(sizeof(struct gsm_mux_net),
> +			netname, name_assign_type,
> +			gsm_mux_net_init);

The indentation is now not correct.  For a function call, all arguments on the
second and subsequent line, must start exactly at the first column after the
openning parenthesis of the function call.

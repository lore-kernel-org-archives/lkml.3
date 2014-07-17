Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbaGQXTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:19:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41434 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaGQXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:19:32 -0400
Date: Thu, 17 Jul 2014 16:19:31 -0700 (PDT)
Message-Id: <20140717.161931.283488873926282207.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [PATCH net-next v9 3/9] net: nl802154 - make add_iface take
 name assign type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405584370-30054-4-git-send-email-teg@jklm.no>
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
	<1405584370-30054-4-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Jul 2014 16:19:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Thu, 17 Jul 2014 10:06:04 +0200

> @@ -192,8 +193,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
>  		if (devname[nla_len(info->attrs[IEEE802154_ATTR_DEV_NAME]) - 1]
>  				!= '\0')
>  			return -EINVAL; /* phy name should be null-terminated */
> +		name_assign_type = NET_NAME_USER;
>  	} else  {
>  		devname = "wpan%d";
> +		name_assign_type = NET_NAME_ENUM;
>  	}
>  
>  	if (strlen(devname) >= IFNAMSIZ)

Just wondering what should happen if "%d" appears in a user provided name.

That would seem to be both USER and ENUM.

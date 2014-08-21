Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaHUXdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:33:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44047 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaHUXdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:33:21 -0400
Date: Thu, 21 Aug 2014 16:33:20 -0700 (PDT)
Message-Id: <20140821.163320.476216950054835385.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fix checksum features handling in
 netif_skb_features()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140815095617.3006CA0BED@unicorn.suse.cz>
References: <20140815095617.3006CA0BED@unicorn.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 16:33:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Fri, 15 Aug 2014 11:56:17 +0200 (CEST)

> @@ -2587,13 +2587,18 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
>  		return harmonize_features(skb, features);
>  	}
>  
> -	features &= (skb->dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |
> -					       NETIF_F_HW_VLAN_STAG_TX);
> +	features = netdev_intersect_features(features, skb->dev->vlan_features |
> +						       NETIF_F_HW_VLAN_CTAG_TX |
> +						       NETIF_F_HW_VLAN_STAG_TX);

This is not indented properly.

The second and subsequent lines of the function call should start precisely
at the first column after the openning parenthesis on the first line.  You
should use the appropriate number of TAB and SPACE characters necessary
to do so.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaLIVAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:00:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38644 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaLIVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:00:51 -0500
Date: Tue, 09 Dec 2014 16:00:48 -0500 (EST)
Message-Id: <20141209.160048.1159420484833054299.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: allow setting LRO independently of
 lower device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141205190937.99BD6A0BB0@unicorn.suse.cz>
References: <20141205190937.99BD6A0BB0@unicorn.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 13:00:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Fri, 5 Dec 2014 17:05:49 +0100

> Since commit fbe168ba91f7 ("net: generic dev_disable_lro() stacked
> device handling"), dev_disable_lro() zeroes NETIF_F_LRO feature flag
> first for a macvlan device and then for its lower device. As an attempt
> to set NETIF_F_LRO to zero is ignored, dev_disable_lro() issues a
> warning and taints kernel.
> 
> Allowing NETIF_F_LRO to be set independently of the lower device
> consists of three parts:
> 
>   - add the flag to hw_features to allow toggling it
>   - allow setting it to 0 even if lower device has the flag set
>   - add the flag to MACVLAN_FEATURES to restore copying from lower
>     device on macvlan creation
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks.

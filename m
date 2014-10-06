Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaJFWQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:16:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJFWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:16:54 -0400
Date: Mon, 06 Oct 2014 18:16:51 -0400 (EDT)
Message-Id: <20141006.181651.2058519626308257571.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, edumazet@google.com, josh@joshtriplett.org,
        courmisch@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH V2 linux-next] net: fix rcu access on phonet_routes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412619321-2212-1-git-send-email-fabf@skynet.be>
References: <1412619321-2212-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Oct 2014 15:16:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon,  6 Oct 2014 20:15:20 +0200

> -Add __rcu annotation on table to fix sparse warnings:
> net/phonet/pn_dev.c:279:25: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:279:25:    expected struct net_device *<noident>
> net/phonet/pn_dev.c:279:25:    got void [noderef] <asn:4>*<noident>
> net/phonet/pn_dev.c:376:17: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:376:17:    expected struct net_device *volatile <noident>
> net/phonet/pn_dev.c:376:17:    got struct net_device [noderef] <asn:4>*<noident>
> net/phonet/pn_dev.c:392:17: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:392:17:    expected struct net_device *<noident>
> net/phonet/pn_dev.c:392:17:    got void [noderef] <asn:4>*<noident>
> 
> -Access table with rcu_access_pointer (fixes the following sparse errors):
> net/phonet/pn_dev.c:278:25: error: incompatible types in comparison expression (different address spaces)
> net/phonet/pn_dev.c:391:17: error: incompatible types in comparison expression (different address spaces)
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: use rcu_access_pointer instead of rcu_dereference out of rcu_read_lock context
>     (suggested by Eric Dumazet).

Applied, thank you.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaLIB33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:29:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIB31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:29:27 -0500
Date: Mon, 08 Dec 2014 20:29:23 -0500 (EST)
Message-Id: <20141208.202923.1673226136424442147.davem@davemloft.net>
To: joe@perches.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] udp: Neaten and reduce size of
 compute_score functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417494546.4894.12.camel@perches.com>
References: <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
	<1417489760.4894.8.camel@perches.com>
	<1417494546.4894.12.camel@perches.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Dec 2014 17:29:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 01 Dec 2014 20:29:06 -0800

> The compute_score functions are a bit difficult to read.
> 
> Neaten them a bit to reduce object sizes and make them a
> bit more intelligible.
> 
> Return early to avoid indentation and avoid unnecessary
> initializations.
> 
> (allyesconfig, but w/ -O2 and no profiling)
> 
> $ size net/ipv[46]/udp.o.*
>    text    data     bss     dec     hex filename
>   28680    1184      25   29889    74c1 net/ipv4/udp.o.new
>   28756    1184      25   29965    750d net/ipv4/udp.o.old
>   17600    1010       2   18612    48b4 net/ipv6/udp.o.new
>   17632    1010       2   18644    48d4 net/ipv6/udp.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

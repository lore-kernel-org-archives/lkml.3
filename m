Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaF3Grf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:47:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50183 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaF3Grd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:47:33 -0400
Date: Sun, 29 Jun 2014 23:47:33 -0700 (PDT)
Message-Id: <20140629.234733.1425327314928423201.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, octavian.purdila@intel.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140630124750.0aad0c82@canb.auug.org.au>
References: <20140630124750.0aad0c82@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Jun 2014 23:47:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 30 Jun 2014 12:47:50 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/net/inet_connection_sock.h:23:0,
>                  from include/linux/tcp.h:24,
>                  from include/net/tcp.h:24,
>                  from net/ipv4/tcp_input.c:72:
> net/ipv4/tcp_input.c: In function 'pr_drop_req':
> include/net/inet_sock.h:77:41: error: 'struct sock_common' has no member named 'skc_v6_daddr'
>  #define ir_v6_rmt_addr  req.__req_common.skc_v6_daddr
>                                          ^
> include/net/sock.h:2273:57: note: in expansion of macro 'ir_v6_rmt_addr'
>   do { if (net_msg_warn && net_ratelimit()) printk(fmt,##args); } while(0)
>                                                          ^
> net/ipv4/tcp_input.c:5889:3: note: in expansion of macro 'LIMIT_NETDEBUG'
>    LIMIT_NETDEBUG(KERN_DEBUG pr_fmt("drop open request from %pI6/%u\n"),
>    ^
> 
> Caused by commit 1fb6f159fd21 ("tcp: add tcp_conn_request").  This
> build has CONFIG_IPV6 unset.

I've just pushed a fix for this, sorry about that.

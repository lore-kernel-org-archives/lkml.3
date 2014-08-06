Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaHFVwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:52:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44071 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaHFVwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:52:19 -0400
Date: Wed, 06 Aug 2014 14:52:18 -0700 (PDT)
Message-Id: <20140806.145218.1742159418901363810.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] tcp: md5: check md5 signature without
 socket lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140807014953.d8c4cde302bb9b30f8efe0e1@qrator.net>
References: <20140807014953.d8c4cde302bb9b30f8efe0e1@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 14:52:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Thu, 7 Aug 2014 01:49:53 +0400

> Since a8afca032 (tcp: md5: protects md5sig_info with RCU) tcp_md5_do_lookup
> doesn't require socket lock, rcu_read_lock is enough. Therefore socket lock is
> no longer required for tcp_v{4,6}_inbound_md5_hash too, so we can move these
> calls (wrapped with rcu_read_{,un}lock) before bh_lock_sock:
> from tcp_v{4,6}_do_rcv to tcp_v{4,6}_rcv.
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Please respin this against the current 'net' tree, it doesn't apply.

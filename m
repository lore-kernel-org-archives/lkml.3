Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaLJSt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:49:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46665 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaLJStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:49:24 -0500
Date: Wed, 10 Dec 2014 13:49:21 -0500 (EST)
Message-Id: <20141210.134921.191006187867269911.davem@davemloft.net>
To: ying.xue@windriver.com
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com, jon.maloy@ericsson.com,
        erik.hugne@ericsson.com, netdev@vger.kernel.org, kbuild-all@01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RESEND 0/2] fix rculist sparse errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
References: <1418201167-9591-1-git-send-email-ying.xue@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 10:49:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>
Date: Wed, 10 Dec 2014 16:46:05 +0800

> When hlist_for_each_entry_continue_rcu_bh() gets "next" pointer of
> hlist_node structure through rcu_dereference_bh(), sparse warning
> appears as the "next" pointer is not annotated as __rcu. So if
> the "next" pointer is accessed with hlist_next_rcu() macro, the
> __rcu annotation will be added to the pointer. As a consequence,
> sparse warning is eliminated too.
> 
> The similar errors also appear in hlist_for_each_entry_continue_rcu()
> and hlist_for_each_entry_from_rcu().
> 
> In this version, CC more people like Paul E. McKenney and lkml mail
> list.

The rculist.h changes should go via Paul's tree, not mine.

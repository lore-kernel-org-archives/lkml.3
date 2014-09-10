Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaIJUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:04:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42987 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaIJUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:04:42 -0400
Date: Wed, 10 Sep 2014 13:04:41 -0700 (PDT)
Message-Id: <20140910.130441.1068300156073509217.davem@davemloft.net>
To: ogerlitz@mellanox.com
Cc: chuck.lever@oracle.com, _govind@gmx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bvanassche@acm.org, saeedm@mellanox.com, talal@mellanox.com,
        yevgenyp@mellanox.com, roland@kernel.org
Subject: Re: 3.17-rc1 oops during network interface configuration
From: David Miller <davem@davemloft.net>
In-Reply-To: <541000F1.5000805@mellanox.com>
References: <53F47917.8080003@mellanox.com>
	<F580F466-28A5-4BDD-A338-D5C065A760C1@oracle.com>
	<541000F1.5000805@mellanox.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Sep 2014 13:04:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>
Date: Wed, 10 Sep 2014 10:42:41 +0300

> Hi Chuck, thanks for bisecting this out. Indeed, as of this kernel 3.2
> commit 936d7de "IPoIB: Stop lying about hard_header_len and use
> skb->cb to stash LL addresses" we are using the skb->cb field to
> enable proper work under GRO and avoid another historical quirk we had
> there... so I think we can definetly consider commit e0f31d849 to
> introduce a severe regression... Govindarajulu, Dave - what's your
> thinking here? any quick idea on how to fix?

Eric mentioned that we could reduce the amount of flow state stored
in the qdisc cb in order to handle this better.

Making skb->cb[] larger is basically out of the question as far as
I'm concerned.

> Also, I was thinking we have the mechanics in the kernel, e.g commit
> a0417fa3a18a ("net: Make qdisc_skb_cb upper size bound explicit.") to
> catch such over-flows?

Yes we should have added a build-time check so that we would discover
this issue more quickly.

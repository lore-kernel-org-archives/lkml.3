Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJKXIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 19:08:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40532 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaJKXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 19:08:33 -0400
Date: Sat, 11 Oct 2014 19:08:29 -0400 (EDT)
Message-Id: <20141011.190829.876705206204533685.davem@davemloft.net>
To: tgraf@suug.ch
Cc: eric.dumazet@gmail.com, heiko.carstens@de.ibm.com, sasha.levin@oracle.com,
        paulmck@linux.vnet.ibm.com, nikolay@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, braunu@de.ibm.com
Subject: Re: [bisected] e341694e3eb5 netlink_lookup() rcu conversion causes
 latencies
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141011222514.GA14186@casper.infradead.org>
References: <20141011083627.GB5074@osiris>
	<1413055964.9362.50.camel@edumazet-glaptop2.roam.corp.google.com>
	<20141011222514.GA14186@casper.infradead.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Oct 2014 16:08:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Sat, 11 Oct 2014 23:25:14 +0100

> I think the issue here is obvious and a fix is on the way to move
> the insertion and removal to a worker to no longer require the
> synchronize_rcu().
> 
> What bothers me is that the synchronize_rcu() should only occur
> on expand/shrink and not for every table update. The default table
> size is 64.

Not true, every netlink socket release incurs a synchronize_net()
now, because we added such a call to netlink_release().

I specifically brought this up to as a possible problem when the
changes went in...

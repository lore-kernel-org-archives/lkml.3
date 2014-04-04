Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaDDPYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:24:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52444 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaDDPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:24:53 -0400
Date: Fri, 04 Apr 2014 11:26:28 -0400 (EDT)
Message-Id: <20140404.112628.1273328398538574058.davem@davemloft.net>
To: peterz@infradead.org
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, ben@decadent.org.uk,
        mkl@pengutronix.de, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1)
 instead of yield() to wait for outstanding qdisc_run callsb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140404151942.GI10526@twins.programming.kicks-ass.net>
References: <20140402110743.GG27965@twins.programming.kicks-ass.net>
	<1396437459.3989.39.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140404151942.GI10526@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 08:24:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 4 Apr 2014 17:19:42 +0200

> The proper way to fix the dev_deactivate_many() is to use wait_event(),
> polling for that state is just daft. Afaict there is no reason the qdisc
> code could not do a wakeup whenever that condition changes.

I actually looked into this, and it's going to add expensive checks
to the fast paths of packet processing.

If it was so easy we'd be doing it that way already.

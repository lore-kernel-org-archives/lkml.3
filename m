Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3GTFNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 01:13:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56195 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3GTFNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 01:13:35 -0400
Date: Fri, 19 Jul 2013 22:13:34 -0700 (PDT)
Message-Id: <20130719.221334.1029630301322767269.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH] bridge: do not call setup_timer() multiple times
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374289636.26476.42.camel@edumazet-glaptop>
References: <51E557C0.2060602@linux.vnet.ibm.com>
	<1374289636.26476.42.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 19 Jul 2013 22:13:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 19 Jul 2013 20:07:16 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> commit 9f00b2e7cf24 ("bridge: only expire the mdb entry when query is
> received") added a nasty bug as an active timer can be reinitialized.
> 
> setup_timer() must be done once, no matter how many time mod_timer()
> is called. br_multicast_new_group() is the right place to do this.
> 
> Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Diagnosed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Cong Wang <amwang@redhat.com>

Applied, thanks a lot Eric.

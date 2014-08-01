Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaHAExr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:53:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54132 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaHAExp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:53:45 -0400
Date: Thu, 31 Jul 2014 21:53:44 -0700 (PDT)
Message-Id: <20140731.215344.1226846407150746376.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-netback: Turn off the carrier if the guest is not
 able to receive
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406749849-4356-2-git-send-email-zoltan.kiss@citrix.com>
References: <1406749849-4356-1-git-send-email-zoltan.kiss@citrix.com>
	<1406749849-4356-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 21:53:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 30 Jul 2014 20:50:49 +0100

> Currently when the guest is not able to receive more packets, qdisc layer starts
> a timer, and when it goes off, qdisc is started again to deliver a packet again.
> This is a very slow way to drain the queues, consumes unnecessary resources and
> slows down other guests shutdown.
> This patch change the behaviour by turning the carrier off when that timer
> fires, so all the packets are freed up which were stucked waiting for that vif.
> Instead of the rx_queue_purge bool it uses the VIF_STATUS_RX_PURGE_EVENT bit to
> signal the thread that either the timout happened or an RX interrupt arrived, so
> the thread can check what it should do. It also disables NAPI, so the guest
> can't transmit, but leaves the interrupts on, so it can resurrect.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

When posting a multi-part patch set, number your patches and have a header
"[PATCH 0/N] " posting which describes at a high level what the patch
series is doing, and why.

> +				for (i = 0; i < num_queues; ++i) {

Please use the more canonical "i++" increment.

Thanks.

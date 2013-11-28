Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3K1XP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 18:15:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3K1XP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 18:15:56 -0500
Date: Thu, 28 Nov 2013 18:15:54 -0500 (EST)
Message-Id: <20131128.181554.1888077442034865299.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: eric.dumazet@gmail.com, jongman.heo@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inet: further fixes of possible seqlock deadlocks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131128221926.GG24171@order.stressinduktion.org>
References: <1385672502.5352.38.camel@edumazet-glaptop2.roam.corp.google.com>
	<20131128212700.GF24171@order.stressinduktion.org>
	<20131128221926.GG24171@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Nov 2013 15:15:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 28 Nov 2013 23:19:26 +0100

> I don't really understand why we distinguish between _BH and plain ICMP stat
> calls then.
> 
> The non-_BH versions deactivate interrupts when updating the per-cpu counter.

This level of distinction exists back in the day where we did per-cpu counters
by hand.  We used to have a BH counter and a non-BH counter for each statistic
and it really helped performance wise.

These days most of that may not be so relevant any more.

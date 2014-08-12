Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaHLWC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:02:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaHLWC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:02:26 -0400
Date: Tue, 12 Aug 2014 15:02:25 -0700 (PDT)
Message-Id: <20140812.150225.33325749199708788.davem@davemloft.net>
To: chas@cmf.nrl.navy.mil
Cc: peterz@infradead.org, fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@01.org,
        linux-atm-general@lists.sourceforge.net
Subject: Re: [PATCH] atm/svc: Fix blocking in wait loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140812081226.0fb0534e@thirdoffive.cmf.nrl.navy.mil>
References: <20140807172514.GY9918@twins.programming.kicks-ass.net>
	<20140807172901.GH3588@twins.programming.kicks-ass.net>
	<20140812081226.0fb0534e@thirdoffive.cmf.nrl.navy.mil>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Aug 2014 15:02:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
Date: Tue, 12 Aug 2014 08:12:26 -0400

> One should not call blocking primitives inside a wait loop, since both
> require task_struct::state to sleep, so the inner will destroy the
> outer state.
> 
> sigd_enq() will possibly sleep for alloc_skb().  Move sigd_enq() before
> prepare_to_wait() to avoid sleeping while waiting interruptibly.  You do
> not actually need to call sigd_enq() after the initial prepare_to_wait()
> because we test the termination condition before calling schedule().
> 
> Based on suggestions from Peter Zijlstra.
> 
> Signed-off-by: Chas Williams <chas@cmf.n4rl.navy.mil>
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaCQRPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:15:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbaCQRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:15:01 -0400
Date: Mon, 17 Mar 2014 18:14:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140317171434.GJ25546@laptop.programming.kicks-ass.net>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <20140317101300.GA27965@twins.programming.kicks-ass.net>
 <20140317165806.GG21124@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317165806.GG21124@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 09:58:07AM -0700, Paul E. McKenney wrote:
> @@ -4111,6 +4115,7 @@ int __sched __cond_resched_softirq(void)
>  {
>  	BUG_ON(!in_softirq());
>  
> +	rcu_cond_resched();

Don't you have to enable BHs before doing that? And if not; that needs a
comment for sure! :-)

>  	if (should_resched()) {
>  		local_bh_enable();
>  		__cond_resched();
> 

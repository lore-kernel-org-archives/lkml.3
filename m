Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3BSSfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:35:20 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47801 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568Ab3BSSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:35:18 -0500
Date: Tue, 19 Feb 2013 10:16:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: False-positive RCU stall warnings on large systems...
Message-ID: <20130219181624.GG3093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5123A984.4000704@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5123A984.4000704@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021918-5406-0000-0000-000005722A06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:34:12AM +0800, Daniel J Blueman wrote:
> Hi Paul,
> 
> On some of our larger servers with many hundreds of cores and when
> under high duress, we can see scheduler RCU stall warnings [1], so
> find we have to increase the hardcoded RCU_STALL_RAT_DELAY up from 2
> and RCU_JIFFIES_TILL_FORCE_QS up from 3.
> 
> Is there a more sustainable way to account for this to avoid it
> being hard-coded, such as making it and dependent timeouts a
> fraction of CONFIG_RCU_CPU_STALL_TIMEOUT?
> 
> On the other hand, perhaps this is just caused by clock jitter (eg
> due to distance from a contended clock source)? So increasing these
> a bit may just be adequate in general...

Hmmm...  What version of the kernel are you running?

							Thanx, Paul

> Many thanks,
>   Daniel
> 
> --- [1]
> 
> [ 3939.010085] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 1, t=29662 jiffies, g=3053, c=3052, q=598)
> [ 3939.020008] INFO: Stall ended before state dump start
> -- 
> Daniel J Blueman
> Principal Software Engineer, Numascale Asia
> 


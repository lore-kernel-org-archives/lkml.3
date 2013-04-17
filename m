Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966269Ab3DQL6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:58:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45623 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966128Ab3DQL6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:58:22 -0400
Date: Wed, 17 Apr 2013 06:58:20 -0500
From: Robin Holt <holt@sgi.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130417115820.GF3658@sgi.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <516D72B7.2040608@linux.vnet.ibm.com>
 <20130416162238.GT3658@sgi.com>
 <20130417074835.GB31607@gmail.com>
 <20130417100317.GE3658@sgi.com>
 <516E880C.9050402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516E880C.9050402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The get/put_online_cpus() doesn't help in this case, because if a
> hotplug operation is started _after_ this function returns, then
> your task will get force migrated - which makes the get/put_online_cpus()
> pointless. What we need to do is *disable* CPU hotplug altogether.
> We need not even enable it back, since we are rebooting/powering off
> anyway.
> 
> So how about using the following patch in your series and using
> cpu_hotplug_disable() to achieve the goal?

I will incorporate it before my patch and utilize.  Thank you very
much as I was at a loss as to what I should be doing.

Robin

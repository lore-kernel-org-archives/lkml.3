Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FZOeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:34:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37046 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3FZOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:34:42 -0400
Date: Wed, 26 Jun 2013 07:34:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        walken@google.com, mingo@kernel.org, linux-arch@vger.kernel.org,
        vincent.guittot@linaro.org, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rostedt@goodmis.org,
        namhyung@kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
        zhong@linux.vnet.ibm.com, netdev@vger.kernel.org, oleg@redhat.com,
        sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to
 prevent CPU offline
Message-ID: <20130626143424.GN3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
 <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com>
 <20130625220026.GG3828@linux.vnet.ibm.com>
 <51CAF624.6060004@linux.vnet.ibm.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062614-7606-0000-0000-00000CCC115C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:29:40PM +0100, David Laight wrote:
> > Once stop_machine() is gone from the CPU offline path, we won't be able
> > to depend on disabling preemption to prevent CPUs from going offline
> > from under us.
> 
> Could you use an rcu-like sequence so that disabling pre-emption
> would be enough?
> 
> Something like rebuilding the cpu list, then forcing yourself
> to run on all the cpu.
> 
> That would be far less intrusive.

It would also increase the latency of CPU-hotunplug operations.

							Thanx, Paul


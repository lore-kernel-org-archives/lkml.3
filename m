Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3LDBNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:13:06 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52654 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LDBNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:13:01 -0500
Date: Tue, 3 Dec 2013 17:12:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 22/41] rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
Message-ID: <20131204011255.GB15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131203233232.928771708@linux.com>
 <20131203233256.509969629@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131203233256.509969629@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120401-6688-0000-0000-0000042470D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:54PM -0600, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out.
> 
> One special case is increment_cpu_stall_ticks().
> A per cpu variable is incremented so use raw_cpu_inc().
> 
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

This does not build on 3.13-rc2.  Ah, need a couple of patches earlier
in the series.

But...  But...  Didn't we recently change -to- __this_cpu_ptr() from
the older __get_cpu_var()?

							Thanx, Paul

------------------------------------------------------------------------
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c: In function ‘rcu_adopt_orphan_cbs’:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c:1943:9: error: implicit declaration of function ‘raw_cpu_ptr’ [-Werror=implicit-function-declaration]
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c:1943:25: warning: initialization makes pointer from integer without a cast [enabled by default]
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c: In function ‘__rcu_process_callbacks’:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c:2322:25: warning: initialization makes pointer from integer without a cast [enabled by default]
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c: In function ‘rcu_barrier_func’:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree.c:2923:25: warning: initialization makes pointer from integer without a cast [enabled by default]
In file included from /media/homes/git/linux-2.6-tip/kernel/rcu/tree.c:3467:0:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree_plugin.h: In function ‘rcu_oom_notify_cpu’:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree_plugin.h:1846:7: warning: assignment makes pointer from integer without a cast [enabled by default]
/media/homes/git/linux-2.6-tip/kernel/rcu/tree_plugin.h: In function ‘increment_cpu_stall_ticks’:
/media/homes/git/linux-2.6-tip/kernel/rcu/tree_plugin.h:1988:3: error: implicit declaration of function ‘raw_cpu_inc’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [kernel/rcu/tree.o] Error 1
make[1]: *** [kernel/rcu/tree.o] Error 2
make: *** [sub-make] Error 2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbaJ3Gjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:39:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36335 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaJ3Gjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:39:32 -0400
Date: Thu, 30 Oct 2014 07:39:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, bp@suse.de,
        yaneti@declera.com, jay.vosburgh@canonical.com, mroos@linux.ee,
        emunson@akamai.com, kevin@scrye.com
Subject: Re: [GIT PULL rcu/urgent-for-mingo] Regression fixes
Message-ID: <20141030063927.GC29004@gmail.com>
References: <20141029180721.GA9127@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029180721.GA9127@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull request contains a couple of fixes for RCU regressions:
> 
> 1.	Complete the work of commit dd56af42bd82 (rcu: Eliminate deadlock
> 	between CPU hotplug and expedited grace periods), which was
> 	intended to allow synchronize_sched_expedited() to be safely
> 	used when holding locks acquired by CPU-hotplug notifiers.
> 	This commit makes the put_online_cpus() avoid the deadlock
> 	instead of just handling the get_online_cpus().
> 
> 2.	Complete the work of commit 35ce7f29a44a (rcu: Create rcuo
> 	kthreads only for onlined CPUs), which was intended to allow
> 	RCU to avoid allocating unneeded kthreads on systems where the
> 	firmware says that there are more CPUs than are really present.
> 	This commit makes rcu_barrier() aware of the mismatch, so that
> 	it doesn't hang waiting for non-existent CPUs.  (And yes, I do
> 	need to force this non-existent-CPU condition into my testing.)
> 
> Both of these changes have been tested by the submitters and have been
> exposed to -next testing.  These changes are needed to avoid system hangs,
> and these system hangs have actually occurred during mainline testing.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git urgent-for-mingo
> 
> for you to fetch changes up to d7e29933969e5ca7c112ce1368a07911f4485dc2:
> 
>   rcu: Make rcu_barrier() understand about missing rcuo kthreads (2014-10-28 13:24:13 -0700)
> 
> ----------------------------------------------------------------
> Paul E. McKenney (2):
>       rcu: More on deadlock between CPU hotplug and expedited grace periods
>       rcu: Make rcu_barrier() understand about missing rcuo kthreads
> 
>  include/trace/events/rcu.h | 18 +++++++++---------
>  kernel/cpu.c               | 14 +++++++++++++-
>  kernel/rcu/tree.c          | 15 ++++++++++-----
>  kernel/rcu/tree.h          |  1 +
>  kernel/rcu/tree_plugin.h   | 33 +++++++++++++++++++++++++++++++++
>  5 files changed, 66 insertions(+), 15 deletions(-)
> 

Pulled, thanks a lot Paul!

	Ingo

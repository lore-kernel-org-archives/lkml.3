Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGQFds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:33:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52451 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaGQFdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:33:45 -0400
Date: Wed, 16 Jul 2014 22:33:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Rationalize kthread spawning
Message-ID: <20140717053334.GL8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140714100604.GA9905@linux.vnet.ibm.com>
 <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53C73BA3.1070303@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C73BA3.1070303@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071705-9332-0000-0000-00000168EA21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:57:39PM -0400, Sasha Levin wrote:
> On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Currently, RCU spawns kthreads from several different early_initcall()
> > functions.  Although this has served RCU well for quite some time,
> > as more kthreads are added a more deterministic approach is required.
> > This commit therefore causes all of RCU's early-boot kthreads to be
> > spawned from a single early_initcall() function.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Hey Paul,
> 
> I've updated to today's -next and my VM started hanging on boot. Bisect
> pointed out this patch.
> 
> I don't have any further info right now, but can provide whatever you'll
> find useful.

Could you please add initcall_debug to qemu's -append list?  If sysrq-T
works that early, its output would be helpful as well.

Your .config would also be helpful.

							Thanx, Paul


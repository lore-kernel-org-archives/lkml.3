Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaLHTFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:05:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaLHTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:05:17 -0500
Date: Mon, 8 Dec 2014 11:05:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH wq/for-3.19 3/3] workqueue: dump workqueues on sysrq-t
Message-Id: <20141208110515.7860d68baca2b3bd46c9dab7@linux-foundation.org>
In-Reply-To: <20141208184035.GE12274@htj.dyndns.org>
References: <20141208174326.GB12274@htj.dyndns.org>
	<20141208174406.GC12274@htj.dyndns.org>
	<20141208174733.GD12274@htj.dyndns.org>
	<20141208100613.ecc66d89.akpm@linux-foundation.org>
	<20141208184035.GE12274@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 13:40:35 -0500 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Mon, Dec 08, 2014 at 10:06:13AM -0800, Andrew Morton wrote:
> > sysrq-t already produces thousands of lines of output.  Maybe create a
> > new keycode for this?
> 
> Believe it or not, we already used up all alphanumerics if we count in
> the arch-specific ones.  Given that the workqueue information would
> primarily be useful in tracking down hangs and we'd want to see the
> dump of tasks in that case anyway, sysrq-t isn't a bad fit for
> appending workqueue dump.  If anybody has a better idea, I'm all ears.

Really.  Upper case?

> ...
> > > +static void pr_cont_pool_info(struct worker_pool *pool)
> > > +{
> > > +	if (pool->cpu >= 0)
> > > +		pr_cont(" cpu=%d", pool->cpu);
> > > +	else if (pool->node != NUMA_NO_NODE)
> > > +		pr_cont(" node=%d", pool->node);
> > > +
> > > +	if (pool->cpu < 0) {
> > > +		static char cpus_buf[PAGE_SIZE];
> > 
> > Ouch.  This could be [NR_CPUS + epsilon]?
> 
> It's bitmap mask printing so each char can show four cpus.  PAGE_SIZE
> should be enough for now but I think we need cpumask_prcont().

I'm not concerned about it being too small ;) Not many people have 16k
CPUs - can it be shrunk?  It's particularly gross when CONFIG_SMP=n!



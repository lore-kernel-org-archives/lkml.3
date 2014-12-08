Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaLHTWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:22:34 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61541 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaLHTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:22:32 -0500
Date: Mon, 8 Dec 2014 14:22:29 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH wq/for-3.19 3/3] workqueue: dump workqueues on sysrq-t
Message-ID: <20141208192229.GF12274@htj.dyndns.org>
References: <20141208174326.GB12274@htj.dyndns.org>
 <20141208174406.GC12274@htj.dyndns.org>
 <20141208174733.GD12274@htj.dyndns.org>
 <20141208100613.ecc66d89.akpm@linux-foundation.org>
 <20141208184035.GE12274@htj.dyndns.org>
 <20141208110515.7860d68baca2b3bd46c9dab7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208110515.7860d68baca2b3bd46c9dab7@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Greg for tty)

On Mon, Dec 08, 2014 at 11:05:15AM -0800, Andrew Morton wrote:
> > Believe it or not, we already used up all alphanumerics if we count in
> > the arch-specific ones.  Given that the workqueue information would
> > primarily be useful in tracking down hangs and we'd want to see the
> > dump of tasks in that case anyway, sysrq-t isn't a bad fit for
> > appending workqueue dump.  If anybody has a better idea, I'm all ears.
> 
> Really.  Upper case?

Greg, would using uppercase chars for sysrq work over the different
types of ttys?

> > > > +static void pr_cont_pool_info(struct worker_pool *pool)
> > > > +{
> > > > +	if (pool->cpu >= 0)
> > > > +		pr_cont(" cpu=%d", pool->cpu);
> > > > +	else if (pool->node != NUMA_NO_NODE)
> > > > +		pr_cont(" node=%d", pool->node);
> > > > +
> > > > +	if (pool->cpu < 0) {
> > > > +		static char cpus_buf[PAGE_SIZE];
> > > 
> > > Ouch.  This could be [NR_CPUS + epsilon]?
> > 
> > It's bitmap mask printing so each char can show four cpus.  PAGE_SIZE
> > should be enough for now but I think we need cpumask_prcont().
> 
> I'm not concerned about it being too small ;) Not many people have 16k
> CPUs - can it be shrunk?  It's particularly gross when CONFIG_SMP=n!

Heh, lemme just go ahead and implement bitmap_pr_cont() and
cpumask_pr_cont().

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaHSTOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:14:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaHSTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:14:05 -0400
Date: Tue, 19 Aug 2014 20:11:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] f7b5d647946: -3.0% dbench.throughput-MB/sec
Message-ID: <20140819191139.GG10146@suse.de>
References: <20140819044134.GB8798@localhost>
 <20140819143428.GC10146@suse.de>
 <20140819154351.GA2697@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819154351.GA2697@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:43:51PM +0800, Fengguang Wu wrote:
> On Tue, Aug 19, 2014 at 03:34:28PM +0100, Mel Gorman wrote:
> > On Tue, Aug 19, 2014 at 12:41:34PM +0800, Fengguang Wu wrote:
> > > Hi Mel,
> > > 
> > > We noticed a minor dbench throughput regression on commit
> > > f7b5d647946aae1647bf5cd26c16b3a793c1ac49 ("mm: page_alloc: abort fair
> > > zone allocation policy when remotes nodes are encountered").
> > > 
> > > testcase: ivb44/dbench/100%
> > > 
> > > bb0b6dffa2ccfbd  f7b5d647946aae1647bf5cd26
> > > ---------------  -------------------------
> > >      25692 ± 0%      -3.0%      24913 ± 0%  dbench.throughput-MB/sec
> > >    6974259 ± 6%     -12.1%    6127616 ± 0%  meminfo.DirectMap2M
> > >      18.43 ± 0%      -4.6%      17.59 ± 0%  turbostat.RAM_W
> > >       9302 ± 0%      -3.6%       8965 ± 1%  time.user_time
> > >    1425791 ± 1%      -2.0%    1396598 ± 0%  time.involuntary_context_switches
> > > 
> > > Disclaimer:
> > > Results have been estimated based on internal Intel analysis and are provided
> > > for informational purposes only. Any difference in system hardware or software
> > > design or configuration may affect actual performance.
> > > 
> > 
> > DirectMap2M changing is a major surprise and doesn't make sense for this
> > machine.
> 
> The ivb44's hardware configuration is
> 
>         model: Ivytown Ivy Bridge-EP
>         nr_cpu: 48
>         memory: 64G
> 
> And note that this is an in-memory dbench run, which is why
> dbench.throughput-MB/sec is so high.
> 

Ok, it's a NUMA machine. I expect in this case that prior to the patch more
local memory would have been used on node 0 due to the fair zone allocation
policy skipping remote nodes. The patch corrects the behaviour of zonelist
but the downside is more remote accesses for processes running on node 0. The
behaviour is correct although not necessarily desirable from a performance
point of view.  Users should boot with numa_zonelist_order=node if it's
a problem.

-- 
Mel Gorman
SUSE Labs

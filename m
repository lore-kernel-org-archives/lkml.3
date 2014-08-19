Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaHSQPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:15:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaHSQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:14:59 -0400
Date: Tue, 19 Aug 2014 17:12:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] f7b5d647946: -3.0% dbench.throughput-MB/sec
Message-ID: <20140819161258.GD10146@suse.de>
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
> > Did the amount of memory in the machine change between two tests?
> 
> Nope. They are back-to-back test runs, so the environment pretty much
> remains the same.

Then how did directmap2m change? The sum of the direct maps should
correspond to the amount of physical memory and this patch has nothing
to do with any memory initialisation paths that might affect this.

-- 
Mel Gorman
SUSE Labs

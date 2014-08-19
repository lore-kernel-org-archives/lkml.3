Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaHSPnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:43:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:35455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaHSPno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:43:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,895,1400050800"; 
   d="scan'208";a="578816591"
Date: Tue, 19 Aug 2014 23:43:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] f7b5d647946: -3.0% dbench.throughput-MB/sec
Message-ID: <20140819154351.GA2697@localhost>
References: <20140819044134.GB8798@localhost>
 <20140819143428.GC10146@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819143428.GC10146@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 03:34:28PM +0100, Mel Gorman wrote:
> On Tue, Aug 19, 2014 at 12:41:34PM +0800, Fengguang Wu wrote:
> > Hi Mel,
> > 
> > We noticed a minor dbench throughput regression on commit
> > f7b5d647946aae1647bf5cd26c16b3a793c1ac49 ("mm: page_alloc: abort fair
> > zone allocation policy when remotes nodes are encountered").
> > 
> > testcase: ivb44/dbench/100%
> > 
> > bb0b6dffa2ccfbd  f7b5d647946aae1647bf5cd26
> > ---------------  -------------------------
> >      25692 ± 0%      -3.0%      24913 ± 0%  dbench.throughput-MB/sec
> >    6974259 ± 6%     -12.1%    6127616 ± 0%  meminfo.DirectMap2M
> >      18.43 ± 0%      -4.6%      17.59 ± 0%  turbostat.RAM_W
> >       9302 ± 0%      -3.6%       8965 ± 1%  time.user_time
> >    1425791 ± 1%      -2.0%    1396598 ± 0%  time.involuntary_context_switches
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> 
> DirectMap2M changing is a major surprise and doesn't make sense for this
> machine.

The ivb44's hardware configuration is

        model: Ivytown Ivy Bridge-EP
        nr_cpu: 48
        memory: 64G

And note that this is an in-memory dbench run, which is why
dbench.throughput-MB/sec is so high.

> Did the amount of memory in the machine change between two tests?

Nope. They are back-to-back test runs, so the environment pretty much
remains the same.

Thanks,
Fengguang

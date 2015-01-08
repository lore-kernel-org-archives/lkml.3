Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbbAHIYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:24:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:63746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbbAHIYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:24:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509194062"
Message-ID: <1420705444.6201.103.camel@linux.intel.com>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Huang Ying <ying.huang@linux.intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: LKP ML <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Jan 2015 16:24:04 +0800
In-Reply-To: <1420703154.12346.10.camel@stgolabs.net>
References: <1420684064.6201.86.camel@linux.intel.com>
	 <1420703154.12346.10.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 23:45 -0800, Davidlohr Bueso wrote:
> On Thu, 2015-01-08 at 10:27 +0800, Huang Ying wrote:
> Cc'ing Peter.
> 
> > FYI, we noticed the below changes on
> > 
> > commit c8c06efa8b552608493b7066c234cfa82c47fcea ("mm: convert i_mmap_mutex to rwsem")
> 
> Same exact everything, except for the lock type. No sharing going on.
> 
> > testbox/testcase/testparams: lituya/unixbench/performance-execl
> > 
> > 83cde9e8ba95d180  c8c06efa8b552608493b7066c2  
> > ----------------  --------------------------  
> >          %stddev     %change         %stddev
> >              \          |                \  
> >     721721 ±  1%    +303.6%    2913110 ±  3%  unixbench.time.voluntary_context_switches
> >      11767 ±  0%      -7.6%      10867 ±  1%  unixbench.score
> 
> And this workload appears to be from execl, right? Make sense with some
> of those numbers!!

Yes.  The test we run for unixbench is execl.

> >  2.323e+08 ±  0%      -7.2%  2.157e+08 ±  1%  unixbench.time.minor_page_faults
> >        207 ±  0%      -7.0%        192 ±  1%  unixbench.time.user_time
> >    4923450 ±  0%      -5.7%    4641672 ±  0%  unixbench.time.involuntary_context_switches
> >        584 ±  0%      -5.2%        554 ±  0%  unixbench.time.percent_of_cpu_this_job_got
> >        948 ±  0%      -4.9%        902 ±  0%  unixbench.time.system_time
> >          0 ±  0%      +Inf%     672942 ±  2%  latency_stats.hits.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
> 
> What does this "hits" thing mean exactly? Since I assume both before and
> after runs have the same level of concurrency when pounding on mmap
> operations, I doubt it means that its the amount of calls into the
> slowpath... in addition the lock is obviously contended so we can forget
> about anything in the fastpath.

I think because you changed mutex to rwsem so there was no rwsem related
statistics data for the parent commit.

Best Regards,
Huang, Ying

> So this is a call_rwsem_down_write_failed() vs __mutex_lock_common()
> issue.
> 
> 
> Thanks,
> Davidlohr
> 
> _______________________________________________
> LKP mailing list
> LKP@lists.01.org
> https://lists.01.org/mailman/listinfo/lkp



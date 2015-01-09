Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbbAIDD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:03:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:33970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbbAIDD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:03:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509656745"
Message-ID: <1420772606.6201.126.camel@linux.intel.com>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Huang Ying <ying.huang@linux.intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Fri, 09 Jan 2015 11:03:26 +0800
In-Reply-To: <1420771673.12346.16.camel@stgolabs.net>
References: <1420684064.6201.86.camel@linux.intel.com>
	 <1420771673.12346.16.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 18:47 -0800, Davidlohr Bueso wrote:
> On Thu, 2015-01-08 at 10:27 +0800, Huang Ying wrote:
> > FYI, we noticed the below changes on
> > 
> > commit c8c06efa8b552608493b7066c234cfa82c47fcea ("mm: convert i_mmap_mutex to rwsem")
> > 
> > 
> > testbox/testcase/testparams: lituya/unixbench/performance-execl
> > 
> > 83cde9e8ba95d180  c8c06efa8b552608493b7066c2  
> > ----------------  --------------------------  
> >          %stddev     %change         %stddev
> >              \          |                \  
> >     721721 ±  1%    +303.6%    2913110 ±  3%  unixbench.time.voluntary_context_switches
> >      11767 ±  0%      -7.6%      10867 ±  1%  unixbench.score
> 
> I simply cannot reproduce this, not even on a large box.
> 
> mutex (83cde9e8ba95d180):
> run1:
> Execl Throughput                               3974.3 lps   (30.0 s, 2 samples)
> Voluntary context switches: 377039
> 
> run2:
> Execl Throughput                               4115.5 lps   (30.0 s, 2 samples)
> Voluntary context switches: 391260
> 
> run3:
> Execl Throughput                               4000.2 lps   (30.0 s, 2 samples)
> Voluntary context switches: 378674
> 
> rwsem (c8c06efa8b552608493b7066c2):
> run1:
> Execl Throughput                               4166.0 lps   (30.0 s, 2 samples)
> Voluntary context switches: 385740
> 
> run2:
> Execl Throughput                               4115.5 lps   (30.0 s, 2 samples)
> Voluntary context switches: 391260
> 
> run3:
> Execl Throughput                               4110.5 lps   (29.9 s, 2 samples)
> Voluntary context switches: 387053
> 
> Since throughput is in the ballpark, so is the benchmark score (in fact
> the rwsem score is slightly better).
> 
> Is this a one time thing or can you observe it again? Any special things
> you guys are doing when running the benchmark? Here are some things I've
> done: cpu gov set to performance, Unixbench taken from
> (http://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz ), used
> default compiler options from unixbench Makefile (that is using the
> solaris 2 option). This pretty much matches the environment info you've
> provided. We've done this lock type comparison exercise plenty of times
> in the past, and I'm a bit surprised to see your numbers.

Is it possible for you to try the reproduce steps in the original
reporting email sent by me?  If you have any question on that steps,
feel free to ask.

Best Regards,
Huang, Ying




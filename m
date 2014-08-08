Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaHHIjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:39:02 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54762 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaHHIi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:38:58 -0400
Date: Fri, 8 Aug 2014 10:38:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [sched/numa] 096aa33863a: -21.4% hackbench.throughput, -20.2%
 netperf.Throughput_Mbps
Message-ID: <20140808083853.GA8919@gmail.com>
References: <20140807105311.GA17655@localhost>
 <53E3C270.1010302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53E3C270.1010302@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 08/07/2014 06:53 AM, Fengguang Wu wrote:
> > Hi Rik,
> > 
> > We noticed the below performance regression in commit
> > 096aa33863a5e48de52d2ff30e0801b7487944f4 ("sched/numa: Decay
> > ->wakee_flips instead of zeroing")
> > 
> > b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
> > ---------------  -------------------------  ---------------------------
> >     122361 ± 0%     -21.4%      96140 ± 0%  lkp-snb01/hackbench/50%-process-pipe
> >     122361 ± 0%     -21.4%      96140 ± 0%  TOTAL hackbench.throughput
> 
> I guess the performance of that benchmark depends on it
> "slipping under the wire" after each time the kernel
> zeroes out ->wakee_flips.
> 
> Depending on repeatedly pulling the wakee back to the same
> node as the waker suggests something else in the kernel may
> be pulling the wakee to another place in the system repeatedly,
> as well, just at a lower frequency (load balancer?).
> 
> I have also noticed that select_idle_sibling often fails to
> find an idle sibling within the LLC domain, even when it
> exists. Fixing that bug sometimes results in lower performance.
> 
> It appears that some of the performance results of the scheduler
> appear on the code acting in an opposite way to its documented
> intention.
> 
> It may be best to revert 096aa33863a for now...

Mind sending a revert patch, with an explanation, a Reported-by, etc?

Thanks,

	Ingo

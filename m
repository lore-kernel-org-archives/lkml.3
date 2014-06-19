Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbaFSLpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:45:47 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:18113 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbaFSLpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:45:46 -0400
Message-ID: <1403178338.20417.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/9] perf bench: Add --repeat option
From: Davidlohr Bueso <davidlohr@hp.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: acme@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 04:45:38 -0700
In-Reply-To: <877g4d8lye.fsf@sejong.aot.lge.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	 <1402942467-10671-2-git-send-email-davidlohr@hp.com>
	 <877g4d8lye.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On Thu, 2014-06-19 at 15:14 +0900, Namhyung Kim wrote:
> Hi Davidlohr,
> 
> On Mon, 16 Jun 2014 11:14:19 -0700, Davidlohr Bueso wrote:
> > There are a number of benchmarks that do single runs and
> > as a result does not really help users gain a general idea
> > of how the workload performs. So the user must either manually
> > do multiple runs or just use single bogus results.
> >
> > This option will enable users to specify the amount of runs
> > (arbitrarily defaulted to 5) through the '--repeat' option.
> > Add it to perf-bench instead of implementing it always in
> > each specific benchmark.
> 
> By adding a top-level option, I think it should be applied to all
> benchmaks - but I guess it only supports sched messaging and futex,
> right?

Yes, for now only those. While there is opportunity for others to use it
as well (perhaps shed-pipe & memcpy/memset), I don't think *all*
benchmarks need multiple runs, ie: numa.

> Also it makes benchmarks to run 5 times (by default) even if the option
> is not given at all, is that your intention?

Yes. 5x seemed prudent for the time being. If the option isn't supported
by some benchmark, then it is safely ignored.

Thanks,
Davidlohr


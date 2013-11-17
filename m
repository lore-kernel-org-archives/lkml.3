Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3KQDls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:41:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:63791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3KQDlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,715,1378882800"; 
   d="scan'208";a="428965430"
Date: Sat, 16 Nov 2013 19:41:34 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131117034134.GA19762@tassilo.jf.intel.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115103405.GA18264@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd say that the default behavior should be what Jiri implemented: get 
> the most out of the situation and inform. But you are right in that 
> 'forcing' all elements of a group to be valid should be possible as 
> well - if a special perf stat option or event format is used.

When something is multiplexed it can have a very 
large measurement error. For workloads that fluctuate quite a bit, and the
fluctuations do not line up well with the multiplexing interval,
the default scaling does not give good results.

So you expect to get good data, but you get very bad data.

When collecting data for a large number of events it is important
to group them correctly, so that events that are directly dependent
on each other in equations are properly grouped.

When explicit groups were added the user likely considered this 
problem, so it's not good to silently override the choices.

If a user doesn't care they can always not use groups.

> Even in that second case it shouldn't say <unsupported> for everything 
> in the result, but should deny the run immediately and return with an 
> error, and should tell the user how many events in the group fit and 
> which ones didn't.

Returning this information would be great, but it would really 
need an extended errno, or just a error string reported out.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

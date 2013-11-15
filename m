Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3KOGfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:35:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36558 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3KOGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:35:01 -0500
Date: Fri, 15 Nov 2013 07:34:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131115063457.GB12442@gmail.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Jiri,
> 
> I was trying the grouping support in perf stat and I was surprised 
> to see that if I create a group that is too big to be scheduled, and 
> where only N out of P events can fit, perf stat still yields counts 
> for the N events. I was expecting 0 counts or <not supported>.
> 
> The kernel semantic is to schedule all the events in a group or 
> none. Perf does something different and this is confusing. If you 
> use explicit grouping then I think you want to group to fail if not 
> all the events can be scheduled:
> 
> On an IvyBridge:
> $ perf stat --g -e
> '{cycles,instructions,branches,branches,branches,branches,branches}'
> noploop 1
>      3 229 417 079 cycles
>      3 223 919 023 instructions              #    1,00  insns per cycle
>      3 220 868 098 branches
>      3 220 868 098 branches
>      3 220 868 098 branches
>      3 220 868 098 branches
>    <not supported> branches
> 
> I think it should be: <not supported> for all events.

Btw., does the kernel side currently support discovery of such 
impossible group scheduling constraints at group setup time? If not 
then it probably should and it should reject them straight away.

Thanks,

	Ingo

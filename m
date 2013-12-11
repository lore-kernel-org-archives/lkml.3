Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LKNrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:47:32 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43445 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3LKNra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:47:30 -0500
Date: Wed, 11 Dec 2013 14:47:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131211134724.GC3101@gmail.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> 
> > * Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:
> >
> >> Hi,
> >> 
> >> This patchset adds support for Intel Processor Trace (PT) extension 
> >> [1] of Intel Architecture that allows the capture of information 
> >> about software execution flow, to the perf kernel and userspace 
> >> infrastructure. We provide an abstraction for it called "itrace" for 
> >> "instruction trace" ([2]).
> >
> > Ok, this feature looks rather interesting.
> >
> > On the hardware side this is essentially BTS (Branch Trace Store) 
> > on steroids (with many extensions), right?
> 
> Yes, you get timestamps and all sorts of other useful data in the 
> trace and the performance intrusion is much less than that of BTS.

So the problem I see here right now that BTS is rarely used and AFAICS 
close to unmaintained. It has some very minimal support in 'perf 
script' but that's all I can see.

So one necessary precondition to merging PT support would be to have a 
convincing case that this kind of stuff is generally useful.

One good approach to do that would be to unify the BTS and PT tooling 
(the kernel side can be unified as well, to the extent it makes 
sense), and to prove it via actual functionality that this stuff 
matters. BTS is available widely, so the tooling can be tested by 
anyone who's interested.

Allow people to record crashes in core dumps, allow them to look at 
histograms/spectrograms of BTS/PT traces, zoom in on actual traces, 
etc. - make it easier to handle this huge amount of data and visualize 
traces in other ways you find useful, etc.

None of that is done right now via BTS so nobody uses it.

Thanks,

	Ingo

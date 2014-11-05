Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaKEMtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:49:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:44994 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaKEMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:49:36 -0500
Date: Wed, 5 Nov 2014 13:49:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Kan Liang <kan.liang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105124926.GS3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
 <20141105104359.GP3337@twins.programming.kicks-ass.net>
 <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 11:57:10AM +0100, Stephane Eranian wrote:
> Yes, but I wonder how would the tool sort this out if you have FP and LBR
> for each sample.

That's the tools 'problem'. It currently can already have FP and Dwarf
bits. And it does not need to request all of them.

> My understanding of the patch is that it does not change the user interface,
> it changes the way callchains are gathered by the kernel on HSW.

I was under the impression it did change, but that shows how well the
Changelog explained things I suppose :/

> Is there explicit mention in the API that CALLCHAIN is relying on FP?

Don't think so. Although I would much prefer if it uses a single method
per arch across both kernel and user space. For x86 that is FP (since
that's the only method available to the kernel).

> I think in general it would be better for tools to know which
> low-level mechanism is used to better interpret the results and
> especially be aware of the limitations of each mechanism.

Agreed.

> I think the patch is trying some auto-promotion of CALLCHAIN to FP
> based on the belief it is better in most cases.

We're all more familiar with FP, and it doesn't have the obvious problem
if only 16 entries. I've worked on quite a bit of software that had much
deeper callchains -- yay for recursive algorithms and/or C++.

With a bit of care FP can be 'perfect', although Andi likes to point out
that glibc isn't and often wrecks FP :-(

> It reminds me of the discussion about precise mode. Why not default to
> precise for all events that support it?

I've no idea where that discussion stranded.

> I would be okay if the patch was introducing the 3rd mode for callchains.

Right, I would prefer that (as should be clear by now), this would allow
running with two (or even all three) and compare results.

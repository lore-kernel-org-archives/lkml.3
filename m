Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaKEKoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:44:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:44265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKEKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:44:07 -0500
Date: Wed, 5 Nov 2014 11:43:59 +0100
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
Message-ID: <20141105104359.GP3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:58:28AM +0100, Stephane Eranian wrote:
> On Wed, Nov 5, 2014 at 10:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Nov 04, 2014 at 09:56:09PM -0500, Kan Liang wrote:
> >> From: Yan, Zheng <zheng.z.yan@intel.com>
> >>
> >> Only enable LBR callstack when user requires fp callgraph. The feature
> >> is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
> >> is required.
> >> Also, this feature only affects how to get user callchain. The kernel
> >> callchain is always got by frame pointers.
> >
> > Since FP callchains should not change, this doesn't appear to make any
> > sense either.
> 
> If I recall earlier discussion, the FP callchain are not changed. On
> HSW, when requesting fp at the user level only, then the kernel
> automatically tries to use the LBR callstack mode.  Advantage is that
> the user app does not require frame-pointer or dwarf debug info to get
> correct callchains with perf record. The downside is that LBR
> callstack does not work in certain callchain corner cases.

But this patch changes the FP callchain interface. I see no need of
that. We already have multiple independent callchain options (FP and
Dwarf) adding a third option should also be independent (LBR).

Allowing all 3 at the same time allows for identifying those corner
cases.

That is I simply don't see a good reason intertwine these things at the
interface level. All it does is reduce options. Would it not be 'nice'
to allow both FP and LBR at the same time?

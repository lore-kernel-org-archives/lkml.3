Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaKERz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:55:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:55118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaKERzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:55:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,321,1413270000"; 
   d="scan'208";a="632070357"
Date: Wed, 5 Nov 2014 09:52:05 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Liang, Kan" <kan.liang@intel.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105175205.GP3274@tassilo.jf.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
 <20141105104359.GP3337@twins.programming.kicks-ass.net>
 <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
 <20141105124926.GS3337@twins.programming.kicks-ass.net>
 <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
 <37D7C6CF3E00A74B8858931C1DB2F077016540B7@SHSMSX103.ccr.corp.intel.com>
 <20141105162932.GX3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105162932.GX3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 05:29:32PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 05, 2014 at 03:53:34PM +0000, Liang, Kan wrote:
> > > I don't think it would be very hard to modify the patch set to make that 3rd
> > > mode visible. Just need to make that new PERF_RECORD_* type visible to
> > > user and modify the compatibility checks.
> > 
> > It's not hard. But LBR is not an independent callchain options. It's better to be
> > a supplement of FP. Otherwise, it may confuse the user. He enables the
> > BRANCH_CALL_STACK, but the data is partly or even not at all from hardware.
> 
> What the user sees is up to userspace. It should not be forced by the
> kernel/user interface.

The original idea was to abstract it inside the kernel. Unlike dwarf the
LBR callstack is simple enough that it can be easily abstracted. If you don't
want to do that yes then handling it in the user tools is the right way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

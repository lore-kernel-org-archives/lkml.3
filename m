Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaKEQ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:29:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbaKEQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:29:41 -0500
Date: Wed, 5 Nov 2014 17:29:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105162932.GX3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
 <20141105104359.GP3337@twins.programming.kicks-ass.net>
 <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
 <20141105124926.GS3337@twins.programming.kicks-ass.net>
 <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
 <37D7C6CF3E00A74B8858931C1DB2F077016540B7@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077016540B7@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:53:34PM +0000, Liang, Kan wrote:
> > I don't think it would be very hard to modify the patch set to make that 3rd
> > mode visible. Just need to make that new PERF_RECORD_* type visible to
> > user and modify the compatibility checks.
> 
> It's not hard. But LBR is not an independent callchain options. It's better to be
> a supplement of FP. Otherwise, it may confuse the user. He enables the
> BRANCH_CALL_STACK, but the data is partly or even not at all from hardware.

What the user sees is up to userspace. It should not be forced by the
kernel/user interface.

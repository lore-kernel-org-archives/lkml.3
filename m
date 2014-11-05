Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKER5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:57:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:8093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaKER5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:57:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,321,1413270000"; 
   d="scan'208";a="632073905"
Date: Wed, 5 Nov 2014 09:57:03 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kan Liang <kan.liang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105175703.GQ3274@tassilo.jf.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
 <20141105104359.GP3337@twins.programming.kicks-ass.net>
 <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
 <20141105124926.GS3337@twins.programming.kicks-ass.net>
 <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> LBR callstack fails for leaf function optimization. Where the callee does
> not return to its caller but instead to the caller's caller. That is the one
> case I know about. There are others I believe.

No it should work fine for this case. You just don't see the tail call,
but the call stack does not get out of sync, so future calls work fine. 
It's the same as with frame pointers or even dwarf.

Typical cases that throw it off are throwing exceptions or user space
context switching.

One somewhat common case that used to throw it off was the
call 1f ; 1: pop %ebx
older 32bit binaries used to do to get the PIC offset. That has been
fixed in newer compilers by using an out of line function
(and also Broadwell has a workaround for this)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

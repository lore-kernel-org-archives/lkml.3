Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaKERk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:40:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:33101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbaKERkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:40:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,321,1413270000"; 
   d="scan'208";a="602892781"
Date: Wed, 5 Nov 2014 09:40:31 -0800
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
Message-ID: <20141105174031.GO3274@tassilo.jf.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason why using LBR call stack mode is restricted to user level
> only is because of
> a bug in the LBR call stack hardware which forces the kernel to drop
> LBR_FREEZE_PMI.

It works with PEBS events, just not with non PEBS (the patch currently
does not implement this distinction and I'm not sure it's worth it)

> In other words ,the LBR does not stop on counter overflow, thus it
> will be wiped out by
> execution of kernel code leading to the PMU interrupt handler.

It stops, but it takes some time to stop so the call-return stack
can get out of sync.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

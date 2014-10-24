Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaJXH7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:59:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:35188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaJXH7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="624509120"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141022145504.GX12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022145504.GX12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 10:59:30 +0300
Message-ID: <87zjcl290d.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

>> +/* make negative table index stand for the last table entry */
>> +#define TOPA_ENTRY(t, i) ((i) == -1 ? &(t)->table[(t)->last] : &(t)->table[(i)])
>
> code does not match comment; negative would be: i < 0, not i == -1.

Indeed.

> Something like: ({ if (i < 0) i += t->size; t->table[i]; }), might work,
> of course that goes bang when: i !e [-size,size)

Table indices and sizes are measured in different units. Using -1 to
mean the last is just a small convenience, in the code it would be used
explicitly as TOPA_ENTRY(topa, -1).end = 1, for example.

Regards,
--
Alex

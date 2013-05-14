Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3ENIhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577Ab3ENIhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:37:18 -0400
Date: Tue, 14 May 2013 11:36:21 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130514083621.GA20995@redhat.com>
References: <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
 <20130510105536.GA18805@gmail.com>
 <20130510112756.GH31235@dyad.programming.kicks-ass.net>
 <20130511075008.GC24435@gmail.com>
 <20130513093624.GC3708@dyad.programming.kicks-ass.net>
 <20130513194313.GA30998@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513194313.GA30998@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 09:43:13PM +0200, Ingo Molnar wrote:
> Note that at least for user-space, REP MOVS is getting rarer. libc uses 
> SSE based memcpy/memset variants - which is not miscounted by PEBS. The 
> kernel still uses REP MOVS - but it's a special case because it cannot 
> cheaply use vector registers.
> 
> The vast majority of code gets measured by cycles:pp more accurately than 
> cycles.
> 
> We could try and see how many people complain. It's not like it's hard to 
> undo such a change of the default event?
> 
People may optimize for a wrong case instead of complaining. There is
nothing that obviously broken, only if you know what to look for the
brokenness can be seen.

--
			Gleb.

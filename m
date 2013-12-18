Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3LROLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:11:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LROLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:11:44 -0500
Date: Wed, 18 Dec 2013 15:11:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131218141125.GT21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
 <20131217161126.GL13532@twins.programming.kicks-ass.net>
 <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218133439.GR21999@twins.programming.kicks-ass.net>
 <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:01:04PM +0200, Alexander Shishkin wrote:
> > Why don't you start by explaining _why_ you need a second stream to
> > begin with?
> 
> Oh, I'm sure I've explained it earlier ([1], [2])

See, I didn't read 0 because that information gets lost and patches
should be self explanatory, and i didn't get to the Intel driver yet
because well, I got stuck in the generic code.

> but why not. The data
> in the second stream is generated at a rate which is hundreds of
> megabytes per second per core. Decoding this data is ~1000 times slower
> than generating it. Ergo, can't be done in kernel, needs to be exported
> as-is to userspace for later retreival and decoding. Doing it via perf
> stream means an extra copy, which at these rates is a waste. Ergo, a
> second buffer.

Still confused, if you cannot copy it into one buffer, then why can you
copy it into a second buffer?


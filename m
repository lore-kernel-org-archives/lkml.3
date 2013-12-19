Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3LSPOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:14:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3LSPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:14:33 -0500
Date: Thu, 19 Dec 2013 16:14:27 +0100
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
Message-ID: <20131219151427.GJ16438@laptop.programming.kicks-ass.net>
References: <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219115759.GS3694@twins.programming.kicks-ass.net>
 <20131219125759.GU3694@twins.programming.kicks-ass.net>
 <87eh58ki1o.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh58ki1o.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:54:27PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Thu, Dec 19, 2013 at 12:57:59PM +0100, Peter Zijlstra wrote:
> > So you're basically forced to stop the tracing on PMI anyhow; so your
> > continuous tracing argument goes out the window.
> 
> It's only stopped inside the PMI handler to set up another buffer, and
> is then started again, so no useful trace is lost. PMI handler is not
> traced. What you're proposing is stopping it for good till perf collects
> the previous data, which will lose us a lot of trace. So my argument
> stands.

That is not what I proposed at all.

The PMI will swizzle the pages and resume recording. If there is no
space in the output buffer, we'll simply re-use the existing pages and
overwrite data.




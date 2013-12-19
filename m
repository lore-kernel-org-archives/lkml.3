Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3LSK0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:26:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3LSK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:26:44 -0500
Date: Thu, 19 Dec 2013 11:26:25 +0100
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
Message-ID: <20131219102625.GC30183@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
 <20131217161126.GL13532@twins.programming.kicks-ass.net>
 <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218133439.GR21999@twins.programming.kicks-ass.net>
 <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:53:44AM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > The thing is; why can't you zero-copy whatever buffer the hardware
> > writes into, into the normal buffer?
> 
> I'm not sure I understand. You mean, have the buffer split between perf
> data and trace data?

Yep, I don't see any reason why this wouldn't work.

When the hardware thing sends an interrupt to notify us its buffer is
'full', stop the recorder, try to create a single record in the buffer
that's big enough + 1 page, then swizzle the hardware pages and the
buffer pages for that record, using the +1 page to page align the actual
data. Then (re)start the hardware on the 'new' pages.



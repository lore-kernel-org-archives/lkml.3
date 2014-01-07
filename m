Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaAGIib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:38:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbaAGIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:38:30 -0500
Date: Tue, 7 Jan 2014 09:38:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20140107083803.GM30183@twins.programming.kicks-ass.net>
References: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106221528.GK30183@twins.programming.kicks-ass.net>
 <8761pw6717.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761pw6717.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 03:10:28PM -0800, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > Also, do clarify the other points I asked about. Esp. the non
> > FREEZE_ON_PMI behaviour of the PT PMI is worrying me immensely.
> 
> The only reason for hardware freeze is when you have a few entries (like
> with LBRs) so the interrupt entry code could overwhelm it.
> 
> But PT is not small, it's gigantic: even with the smallest buffer you
> have many thousands of entries.
> 
> So you will get a few branches in the interrupt entry, but it's not a problem
> because everything you really wanted to trace is still there.
> 
> Eventually the handler disables PT, so there's no risk of racing with
> the update or anything like that.
> 
> Did I miss anything?

Yes; go read this:

 lkml.kernel.org/r/20131219125205.GT3694@twins.programming.kicks-ass.net

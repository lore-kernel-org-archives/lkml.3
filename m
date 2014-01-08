Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaAHIcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:32:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52089 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaAHIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:32:11 -0500
Date: Wed, 8 Jan 2014 09:31:52 +0100
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
Message-ID: <20140108083152.GI2480@laptop.programming.kicks-ass.net>
References: <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106221528.GK30183@twins.programming.kicks-ass.net>
 <8761pw6717.fsf@tassilo.jf.intel.com>
 <20140107083803.GM30183@twins.programming.kicks-ass.net>
 <20140107154255.GB20765@two.firstfloor.org>
 <20140107205145.GE2480@laptop.programming.kicks-ass.net>
 <20140107212322.GE20765@two.firstfloor.org>
 <20140108082840.GH2480@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108082840.GH2480@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

restoring the list.. I really should drop all emails you send off list
into /dev/null.

On Wed, Jan 08, 2014 at 09:28:40AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 10:23:22PM +0100, Andi Kleen wrote:
> > > Yes we very much rely on the FREEZE bits for LBR. PT and LBR being
> > > mutually exclusive wasn't documented (or I missed it) and completely
> > > blows.
> > 
> > Can you describe why it is a problem? I had considered it only a minor
> > inconvenience, for many things you would use LBRs for PT is far better.
> 
> Because is someone writes a GCC tool using perf-LBR support for some
> basic block analysis, and someone else writes another tool for PT, then
> the first tool magically stops working when the PT tool is started.
> 
> We cannot refuse to create perf-LBR events, because at that time there
> might not be a PT user -- and even if there was one, it might go away.
> 
> But as long as there's a PT user around, the LBR events will not be able
> to be scheduled and will simply starve, for no apparent reason.
> 
> Complete and utterly miserable position.
> 
> And it makes sense to write LBR tools because they cover a much greater
> spread of hardware.

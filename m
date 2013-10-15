Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3JOOjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:39:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57811 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab3JOOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:39:41 -0400
Date: Tue, 15 Oct 2013 16:39:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015143931.GN10651@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143631.GZ227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015143631.GZ227855@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:36:31AM -0400, Don Zickus wrote:
> > > +refill:
> > > +	if (kernel_ip(ip)) {
> > > +		u8 *buf = &__get_cpu_var(insn_page[0]);
> > > +		size = PAGE_SIZE - ((unsigned long)to & (PAGE_SIZE-1));
> > > +		if (size < MAX_INSN_SIZE) {
> > > +			/*
> > > +			 * If we're going to have to touch two pages; just copy
> > > +			 * as much as we can hold.
> > > +			 */
> > > +			size = PAGE_SIZE;

> Quick thoughts?

Yeah, see the patch I just send; but notably I got the kernel_ip(ip)
case the wrong way about. See how it copies userspace memory for kernel
IPs and vice versa.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaBSTj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:39:29 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52503 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754486AbaBSTj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:39:27 -0500
Date: Wed, 19 Feb 2014 11:37:34 -0800
From: Drew Richardson <drew.richardson@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140219193724.GA27267@dreric01-Precision-T1600>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
 <20140219162819.GP15586@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219162819.GP15586@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 19 Feb 2014 19:37:38.0587 (UTC) FILETIME=[0BFD3EB0:01CF2DAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:28:19PM +0000, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 10:18:31AM +0000, Will Deacon wrote:
> > On Mon, Feb 10, 2014 at 10:17:59PM +0000, Drew Richardson wrote:
> > > While adding CPU on/offlining support during perf captures I get an
> > > Oops both on ARM as well as my desktop x86_64. Below is a small
> > > program that duplicates the issue.
> > 
> > [...]
> > 
> > FWIW I can reproduce this easily with -rc3 on my x86 laptop running
> > hackbench in parallel with a tweaked version of your test (using
> > _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF and hotplugging off
> > both CPU2 and CPU3).
> > 
> 
> OK; found it, or at least, I stopped being able to make my box explode.
> 
> Drew, can you try the below and confirm? Its still got all the debug goo
> in too, but *shees* took me long enough.

This works great for me. No Oops or garbage data when a core is
offlined.

> +	raw_spin_lock(&ctx->lock);
> +	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
> +
> +	list_for_each_entry(event, &ctx->event_list, event_entry)
> +		event->state = PERF_EVENT_STATE_off;
> +
> +	raw_spin_unlock(&ctx->lock);

I changed PERF_EVENT_STATE_off to PERF_EVENT_STATE_OFF.

Drew

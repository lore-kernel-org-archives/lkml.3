Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3J2IhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:37:10 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48411 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3J2IhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:37:02 -0400
Date: Tue, 29 Oct 2013 09:36:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, Stephane Eranian <eranian@google.com>
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
Message-ID: <20131029083657.GB17514@localhost.localdomain>
References: <20131025150721.GA12534@sdfg.com.ar>
 <8761si9e1u.fsf@sejong.aot.lge.com>
 <20131028084244.GA7482@sdfg.com.ar>
 <877gcx92yd.fsf@sejong.aot.lge.com>
 <20131028092955.GB7482@sdfg.com.ar>
 <526E9429.20803@fb.com>
 <87mwls7ouf.fsf@sejong.aot.lge.com>
 <526F353E.8040607@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F353E.8040607@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:10:38PM -0700, Arun Sharma wrote:
> On 10/28/13 8:11 PM, Namhyung Kim wrote:
> 
> Hey Namhyung:
> 
> >>
> >>Also, what's the reasoning for --cumulate not being an option under
> >>perf record -g ..,<order>?
> >
> >Sorry, I cannot understand you.  The 'perf record' just saves sample
> >data (and callchains) from the ring-buffer.  All the processing happens
> >in 'perf report'.  I can't see what you expect from the 'perf record
> >--cumulate'.  Am I missing something?
> 
> Yes - I meant to say perf report -g :)
> 
> > -g [type,min[,limit],order]
> 
> Specifically, along with callee, caller, we could have a third
> option. Or we could have a new type (graph, fractal, cumulative).
> 
> >>Given that there are clear use cases in production involving complex
> >>callgraphs, I'm for getting this support in first and then reconciling
> >>the differences with perf record -b later.
> >
> >I think what Frederic said is that the code de-duplication of 'perf
> >report' side.  The branch stack and --cumulate are different - branch
> >stack concentrates on the branch itself but --cumulate uses callchains
> >to find parents and give some credit to them as side information.
> 
> Me too. I brought it up with Stephane at some point in the last year
> or so and there wasn't an obvious way to de-duplicate because of
> these differences.

I agree that the interface is debatable. It could be -g ...,cumulative, expand -b, or whatever.
But the backend is the same:  perf_report__add_branch_hist_entry should be shared 80%.

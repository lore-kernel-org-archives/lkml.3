Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbbAPSyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:54:16 -0500
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:33221 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbbAPSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:54:13 -0500
Date: Fri, 16 Jan 2015 13:54:09 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference before
 moving the group
In-Reply-To: <20150116141104.GD21958@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1501161352070.8204@pianoman.cluster.toy>
References: <20150116075746.GB2658@krava.brq.redhat.com> <20150116104644.GW23965@worktop.programming.kicks-ass.net> <20150116141104.GD21958@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.54B95E54.015B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Peter Zijlstra wrote:
> On Fri, Jan 16, 2015 at 11:46:44AM +0100, Peter Zijlstra wrote:
> > Its a bandaid at best :/ The problem is (again) that we changes
> > event->ctx without any kind of serialization.
> > 
> > The issue came up before:
> > 
> >   https://lkml.org/lkml/2014/9/5/397
> > 
> > and I've not been able to come up with anything much saner.
> 
> A little something like the below is the best I could come up with; I
> know Linus hated it, but I figure we ought to do something to stop
> crashing.

I just wanted to report that I've tested both this patch and Jiri's 
original one and they both keep my easy-to-trigger-testcase from crashing 
my core2 machine (when applied against 3.18).

This is great!  I've been chasing this bug for months.

Vince

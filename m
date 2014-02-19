Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaBSSga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:36:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaBSSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:36:28 -0500
Date: Wed, 19 Feb 2014 19:36:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Drew Richardson <drew.richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140219183623.GL27965@twins.programming.kicks-ass.net>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
 <20140219162819.GP15586@twins.programming.kicks-ass.net>
 <CABPqkBQS355_XW-2KthkdZkzQnApRvOpANkB3SnfFyac-qsJaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQS355_XW-2KthkdZkzQnApRvOpANkB3SnfFyac-qsJaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 07:03:13PM +0100, Stephane Eranian wrote:
> I am trying to understand the context here.
> Are you saying, we may call an offline CPU?

Yes, that is what's happening.

> I saw that sometimes you retry, sometimes you don't.

I tried to do exactly what we do for the task case which is far more
likely to fail. Could be I messed up.

I should probably write the function differently and have a common retry
path instead of duplicating everything.

> For perf_cgroup_attach(), we invoke task_function_call()
> to force a PMU context switch on the task which is now monitored in cgroup mode.
> If the CPU is offline then, the task is switched out and monitoring
> has been stoppe,
>  no need to retry or do anything more.
> 
> For perf_cgroup_exit(), this is pretty much the same logic.
> 
> am I missing anything else?

Don't think so; I'll add a comment there. I was just too tired to make
sense of things.

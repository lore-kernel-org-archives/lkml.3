Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaDPR1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:27:05 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57293 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaDPR06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:26:58 -0400
Date: Wed, 16 Apr 2014 13:30:06 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140416141514.GS11182@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <20140416141514.GS11182@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Peter Zijlstra wrote:

> Does the below make any difference? I've only ran it through some light
> testing to make sure it didn't insta-explode on running.
> 
> (perf stat make -j64 -s in fact)

I'm running with your patch now and so far so good.

Unfortunately the problem isn't repeatable, but it usually shows up within 
an hour or so of fuzzing (although there's possibly a 2nd unrelated bug 
that also shows up sometimes).

If you want to try running the fuzzer on your machine too just do:
	git clone https://github.com/deater/perf_event_tests.git
	cd fuzzer
	make
and then try running the "./fast_repro98.sh" script, as that's the forking 
workload I've been using when tracking this issue.

Vince

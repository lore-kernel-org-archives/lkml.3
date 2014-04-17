Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaDQPci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:32:38 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44257 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDQPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:32:29 -0400
Date: Thu, 17 Apr 2014 11:35:45 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140417145418.GM11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404171131580.22226@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu> <20140416141514.GS11182@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
 <20140417094815.GA9348@gmail.com> <20140417114533.GJ11096@twins.programming.kicks-ass.net> <20140417142213.GA29338@gmail.com> <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Peter Zijlstra wrote:
> 
> Meh.. my machine keeps locking up with 15-rc1 and your fuzzer. It looks
> to get stuck a finish_task_switch() from a preemption while waiting for
> a perf IPI.
> 
> Which is complete crack because we have preemption disabled over
> issueing and waiting for the IPI :/
> 
> I tried reverting some of the IPI related patches, but no joy so far,
> I'm about to go try a git-bisect on this.

Bisecting can be a pain, as if you go too far back you start running into 
other bugs that have been fixed due to the fuzzer.

Over the past year there's been at least 10 perf_fuzzer-related crash 
fixes that have gotten into the kernel.  It used to be I could crash 
things in seconds, it's now up to minutes-hours but the bugs are that much 
harder to isolate :(

And I still am not fuzzing with signal-overflow enabled, which 
causes even more pain.

Vince

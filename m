Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3KOKT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:19:56 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63152 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3KOKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:19:50 -0500
Date: Fri, 15 Nov 2013 14:19:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115101946.GG1754@moon>
References: <20131115032907.GA25243@redhat.com>
 <20131115100254.GC2965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115100254.GC2965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:02:54AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 14, 2013 at 10:29:07PM -0500, Dave Jones wrote:
> > BUG: using smp_processor_id() in preemptible [00000000] code: trinity-main/890
> > caller is p4_pmu_schedule_events+0x25/0x4c0
> 
> Whee, wherever did you dig up that dinosaur ;-)

rofl ;)
> 
> Hrmm, I'm not entire sure what we should do here; Cyrill, do you have clue?

We need figure out which cpu we're scheduled on to properly choose thread.
I have a vague memory that earlier I've raw_smp_processor_id here but then
someone pointed that we need smp_processor_id instead. Gimme some time,
I'll cook a patch today.

Thanks for report, Dave!

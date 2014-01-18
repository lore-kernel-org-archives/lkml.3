Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaARVyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 16:54:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaARVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:54:48 -0500
Date: Sat, 18 Jan 2014 22:54:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Galbraith <bitbucket@online.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140118215431.GO11314@laptop.programming.kicks-ass.net>
References: <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
 <20140116222536.GX30183@twins.programming.kicks-ass.net>
 <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
 <52D8625C.1000902@zytor.com>
 <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
 <1390038366.5676.10.camel@marge.simpson.net>
 <20140118124451.GA30183@twins.programming.kicks-ass.net>
 <1390058494.5439.3.camel@marge.simpson.net>
 <52DAD2B1.2050401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DAD2B1.2050401@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 11:14:57AM -0800, H. Peter Anvin wrote:
> >> Could something like this work?
> >>
> >> 	local_irq_enable();
> >> 	mwait_idle_with_hints(0,0);
> >>

> This means an interrupt window is open and we can take an interrupt
> between checking need_resched and the MWAIT, which couldn't happen with
> __sti_mwait().
> 
> Are we sure that is actually safe?

current_set_polling_and_test() vs resched_task() should be good that
way, but I've got a terrible head-ache today so don't rely on anything
much I say.

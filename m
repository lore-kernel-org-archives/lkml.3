Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3JHUff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:35:35 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51342 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3JHUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:35:31 -0400
Date: Tue, 8 Oct 2013 22:35:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008203526.GG8392@localhost.localdomain>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131005070806.GA16922@gmail.com>
 <20131005170552.GI6882@two.firstfloor.org>
 <20131008195556.GD8392@localhost.localdomain>
 <20131008200521.GE13848@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008200521.GE13848@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:05:21PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 08, 2013 at 09:55:59PM +0200, Frederic Weisbecker wrote:
> > 1) make breakpoints independant from perf. The drawback is that we must then
> > add seperate hooks on context switch for ptrace breakpoints. OTOH we get
> > rid of the perf -> breakpoint -> perf circular dependency, which is the very
> > controversial thing.
> 
> we used to have this in __switch_to_xtra(), right?

Right.

And then it got replaced by perf events scheduling.

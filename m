Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3JHT4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:56:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54873 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3JHT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:56:05 -0400
Date: Tue, 8 Oct 2013 21:55:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008195556.GD8392@localhost.localdomain>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131005070806.GA16922@gmail.com>
 <20131005170552.GI6882@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005170552.GI6882@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 07:05:52PM +0200, Andi Kleen wrote:
> On Sat, Oct 05, 2013 at 09:08:06AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > As suggested by Ingo.
> > 
> > No, you haven't read my suggestion carefully enough so NAK.
> 
> Ok I trust you will do a better solution then to save the 700+k text.
> Ball is in your court.

Ok I have two choices in mind.

1) make breakpoints independant from perf. The drawback is that we must then
add seperate hooks on context switch for ptrace breakpoints. OTOH we get
rid of the perf -> breakpoint -> perf circular dependency, which is the very
controversial thing.


2) Build breakpoints conditionally (depend on CONFIG_EXPERT). hpa didn't like
much that solution because breakpoints is an elementary debugging feature that
is too useful to be unbuild.

Both ways can allow us to disable perf on x86.

We just need to agree on a solution and I'll happily work on it.

Ingo, others?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3EGGsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:48:11 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57130 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3EGGsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:48:09 -0400
Date: Tue, 7 May 2013 08:48:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130507064804.GE17705@gmail.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
 <20130502073720.GH7521@dyad.programming.kicks-ass.net>
 <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
 <20130506185226.GA17723@dyad.programming.kicks-ass.net>
 <CABPqkBREmUfuPBvCvBF+4YNvzfuqgDffVvfUFE5_w6Yx88mBZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBREmUfuPBvCvBF+4YNvzfuqgDffVvfUFE5_w6Yx88mBZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, May 6, 2013 at 8:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, May 06, 2013 at 07:44:19PM +0200, Stephane Eranian wrote:
> >> On Thu, May 2, 2013 at 9:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Wed, Apr 24, 2013 at 04:04:54PM -0700, Andi Kleen wrote:
> >> >> From: Andi Kleen <ak@linux.intel.com>
> >> >>
> >> >> The PEBS documentation in the Intel SDM 18.6.1.1 states:
> >> >>
> >> >> """
> >> >> PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
> >> >> zero: AnyThread, Edge, Invert, CMask.
> >> >> """
> >> >>
> >> >> Since we had problems with this earlier, don't allow cmask, any, edge, invert
> >> >> as raw events, except for the ones explicitly listed as pebs_aliases.
> >> >
> >> > If its a simple matter of crap in crap out without affecting anything else we
> >> > shouldn't do anything.
> >> >
> >> The problem here is that you are sampling an instruction which did not cause
> >> the event you are measuring. Remember that using cmask, changes the
> >> nature of what's being measured (from event to cycles).
> >
> > Yeah.. I don't see the problem though. If you're using cmask and the like
> > you're supposed to know wth you're doing; which includes knowing your cpu and
> > what it thinks of such an event.
>
> But that implies that you'd know that on Intel precise mode uses PEBS 
> and that PEBS does not take cmask events. That seems to contradict the 
> philosophy of perf_events where the kernel does the work for you.

Also, this code only runs when the event is set up, so a bit of sanity 
checking can only help, right?

Thanks,

	Ingo

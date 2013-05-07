Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3EGLEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:04:21 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54433 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3EGLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:04:19 -0400
Date: Tue, 7 May 2013 13:04:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130507110415.GA20999@gmail.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
 <20130502073720.GH7521@dyad.programming.kicks-ass.net>
 <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
 <20130506185226.GA17723@dyad.programming.kicks-ass.net>
 <CABPqkBREmUfuPBvCvBF+4YNvzfuqgDffVvfUFE5_w6Yx88mBZQ@mail.gmail.com>
 <20130507064804.GE17705@gmail.com>
 <20130507084803.GD9688@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507084803.GD9688@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 07, 2013 at 08:48:05AM +0200, Ingo Molnar wrote:
> > Also, this code only runs when the event is set up, so a bit of sanity 
> > checking can only help, right?
> 
> Nah, its all very circumspect. In fact; while what Andi states is 'true':
> 
> > documentation in the Intel SDM 18.6.1.1 states:
> >
> > """
> > PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
> > zero: AnyThread, Edge, Invert, CMask.
> > """
> 
> It is also true that Intel themselves gave us events that contradict this; look
> at the intel_pebs_aliases*() functions.
>
> This patch would make it impossible to manually create those events.

I missed that bit of obfuscation ...

> Further, there's something entirely different behind this.

Ok, I agree with you, this needs to be fully explained.

Thanks,

	Ingo

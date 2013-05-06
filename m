Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3EFPai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:30:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49929 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3EFPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:30:36 -0400
Date: Mon, 6 May 2013 17:28:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130506152850.GA17623@dyad.programming.kicks-ass.net>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com>
 <CAPM31RJSi1X4PbK86NKiAJFtiq7q2_3t4Ke=sqgXO5rLjbeh7A@mail.gmail.com>
 <5187CB8E.6090303@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5187CB8E.6090303@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:26:06PM +0800, Alex Shi wrote:
> On 05/06/2013 06:22 PM, Paul Turner wrote:
> >>> >> This is missing a scale_load() right?  Further: Why not put this in
> >>> >> __sched_fork?
> >> >
> >> > scale_load is not working now. Anyway I can add this.
> > I believe someone tracked down a plausible cause for this:
> > A governor was examining the values and making a mess with the scaled
> > ones.  I'm sorry, I don't have the post off hand.
> > 
> > You actually likely ideally want this _on_ for these patches; the
> > available resolution with SCHED_LOAD_SHIFT=10 disappears really
> > quickly and scaling by runnable_avg only further accelerates that.
> 
> Sorry for can not follow you. Do you mean the scaling by runnable_avg is
> better than scale_load?
> 
> In fact, after think twice of scale_load, guess better to figure out a
> good usage for it before enabling blindly.

He's saying its way too easy to run out of fractional bits with the current
setup; adding the 10 extra fractional bits provided by SCHED_LOAD_SHIFT is
advantagous and we should re-enable that.

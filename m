Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3F1LI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:08:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3F1LI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:08:27 -0400
Date: Fri, 28 Jun 2013 13:07:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, jkosina@suse.cz,
        Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        fweisbec@gmail.com
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
Message-ID: <20130628110730.GA6626@twins.programming.kicks-ass.net>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
 <51C7B9B8.6090309@intel.com>
 <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com>
 <51C867CF.70908@intel.com>
 <CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 03:56:25AM -0700, Paul Turner wrote:

> So this is actually an interesting idea, but don't think of it as
> overweight.  What "cfs_rq->blocked_load_avg / 2" means is actually
> blocked_load_avg one period from now.  This is interesting because it
> makes the (reasonable) supposition that blocked load is not about to
> immediately wake, but will continue to decay.
> 
> Could you try testing the gvr_lb_tip branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/pjt/sched-tip.git ?
> 
> It's an extension to your series that tries to improve some of the
> cpu_load interactions in an alternate way to the above.
> 
> It seems a little better on one and two-socket machines; but we
> couldn't reproduce/compare to your best performance results since they
> were taken on larger machines.

Oh nice.. it does away with the entire cpu_load[] array thing. Just what
Frederic needs for his NOHZ stuff as well -- he's currently abusing
LB_BIAS for that.

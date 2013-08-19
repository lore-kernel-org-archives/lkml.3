Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3HSK6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:58:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56994 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3HSK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:58:51 -0400
Date: Mon, 19 Aug 2013 12:58:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130819105817.GD24092@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130816164922.GA1573@redhat.com>
 <20130816171208.GJ24210@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816171208.GJ24210@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 07:12:09PM +0200, Frederic Weisbecker wrote:
> Or may be Peter could tell us as well. Peter, do you have a preference?

Still trying to wrap my head around it, but conceptually
get_cpu_iowait_time_us() doesn't make any kind of sense. iowait isn't
per cpu since effectively tasks that aren't running aren't assigned a
cpu (as Oleg already pointed out).

The fact that cpufreq 'needs' this just means that cpufreq is broken --
but I think I've said as much previously; cpufreq needs to stop living
in the partitioned-mp era and get dragged (kicking and screaming) into
the smp era.

I'm also not entirely clear on the 'desired' semantics here. Do we count
iowait time as idle or not?

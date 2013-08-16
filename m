Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3HPRMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:12:18 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40502 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3HPRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:12:13 -0400
Date: Fri, 16 Aug 2013 19:12:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130816171208.GJ24210@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130816164922.GA1573@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816164922.GA1573@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 06:49:22PM +0200, Oleg Nesterov wrote:
> On 08/16, Frederic Weisbecker wrote:
> >
> > tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
> > All we need is just a new field in ts-> that records on which state we entered
> > idle.
> 
> Or we can turn ->idle_active into enum. And all other nr_iowait_cpu's
> in this code should go away.
> 
> Personally I am fine either way.

Me too.

So my proposition is that we can keep the existing patches as they fix other distinct races
(and we add fixes on what peterz just reported) and send them to Ingo. Ah and I'll wait for
your review first.

Then if all goes well on the pull request we describe him the nr_iowait race and we let him
choose what to do with that nr_iowait migration race: either we ignore the
migration and always account to what we saw on idle start, or we flush that time accounting
on iowait migration, but that requires seqlocks on the idle path.

Or may be Peter could tell us as well. Peter, do you have a preference?

Thanks.

> 
> Oleg.
> 

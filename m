Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3LEAcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:32:08 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60793 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3LEAcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:32:06 -0500
Date: Thu, 5 Dec 2013 01:32:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] posix-timers: Remove dead process posix cpu timers
 caching
Message-ID: <20131205003201.GB6683@localhost.localdomain>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
 <1385221040-24731-3-git-send-email-fweisbec@gmail.com>
 <529F797A.6010107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F797A.6010107@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:50:34PM -0500, KOSAKI Motohiro wrote:
> > @@ -1090,13 +1063,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
> >  			timer->it.cpu.expires = 0;
> >  			goto out_unlock;
> >  		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
> > -			/*
> > -			 * We've noticed that the thread is dead, but
> > -			 * not yet reaped.  Take this opportunity to
> > -			 * drop our task ref.
> > -			 */
> > +			/* Optimizations: if the process is dying, no need to rearm */
> >  			cpu_timer_sample_group(timer->it_clock, p, &now);
> 
> Why do we still need to call cpu_timer_sample_group? You removed to below line which uses
> "now".

Good point, it looks safe to remove it now.

Thanks.
 
> > -			clear_dead_task(timer, now);
> >  			goto out_unlock;
> >  		}
> >  		spin_lock(&p->sighand->siglock);
> > 
> 

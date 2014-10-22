Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaJVVJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:09:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59984 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbaJVVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:09:49 -0400
Date: Wed, 22 Oct 2014 14:09:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141022210943.GL4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
 <20141022143837.GW4977@linux.vnet.ibm.com>
 <20141022165433.GA22874@linux.vnet.ibm.com>
 <20141022185712.GA9570@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1410222255540.17725@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410222255540.17725@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102221-0025-0000-0000-0000058C332F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:57:25PM +0200, Jiri Kosina wrote:
> On Wed, 22 Oct 2014, Paul E. McKenney wrote:
> 
> > rcu: More on deadlock between CPU hotplug and expedited grace periods
> > 
> > Commit dd56af42bd82 (rcu: Eliminate deadlock between CPU hotplug and
> > expedited grace periods) was incomplete.  Although it did eliminate
> > deadlocks involving synchronize_sched_expedited()'s acquisition of
> > cpu_hotplug.lock via get_online_cpus(), it did nothing about the similar
> > deadlock involving acquisition of this same lock via put_online_cpus().
> > This deadlock became apparent with testing involving hibernation.
> > 
> > This commit therefore changes put_online_cpus() acquisition of this lock
> > to be conditional, and increments a new cpu_hotplug.puts_pending field
> > in case of acquisition failure.  Then cpu_hotplug_begin() checks for this
> > new field being non-zero, and applies any changes to cpu_hotplug.refcount.
> > 
> 
> Yes, this works. FWIW, please feel free to add 
> 
> 	Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>
> 
> once merging it.

Done, and thank you for both the bug report and the testing!

> Why lockdep produced such an incomplete stacktrace still remains 
> unexplained.

On that, I must defer to people more familiar with stack frames.

							Thanx, Paul

> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 


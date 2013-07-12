Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab3GLRDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965101Ab3GLRDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:03:49 -0400
Date: Fri, 12 Jul 2013 13:00:18 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
Message-ID: <20130712170018.GA1537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Hansen <dave@sr71.net>, Dave Hansen <dave.hansen@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
References: <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
 <20130710154029.GB11309@redhat.com>
 <20130712103117.GA14862@gmail.com>
 <51E0230C.9010509@intel.com>
 <20130712154521.GD1020@redhat.com>
 <51E026F3.6010505@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E026F3.6010505@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 08:55:31AM -0700, Dave Hansen wrote:

 > I mean that somebody turned 'active_events' on without actually wanting
 > perf to be on.  I'd be curious how it got set to something nonzero.
 > Could you stick a WARN_ONCE() or printk_ratelimit() on the three sites
 > that modify it?
 
I'll add to my list of things to get to, but it probably won't be until post-weekend.

 > > Here's a fun trick:
 > > 
 > > trinity -c perf_event_open -C4 -q -l off
 > > 
 > > Within about a minute, that brings any of my boxes to its knees.
 > > The softlockup detector starts going nuts, and then the box wedges solid.
 > 
 > *But* dropping the perf sample rate has been really effective at keeping
 > me from hitting it, and I've had to use _lots_ of CPUs (60-160) doing
 > those NMIs at once to trigger the lockups.
 > 
 > Being able to trigger it with so few CPUs is interesting though.  I'll
 > try on my hardware.

I hacked trinity to pause for 24s after each call, and changed the kernel
to taint on lockup (so that trinity would immediatly stop).
My hope was to find the combination of perf_event_open calls that triggered this.
After 12 hours, it's still ticking along. It's now done about a thousand
more calls than is usually necessary to hit the bug. Which makes me wonder
if this is timing related somehow.

Perhaps also worth noting that the majority of calls trinity makes will -EINVAL

	Dave


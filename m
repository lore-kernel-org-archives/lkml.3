Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab3GLRvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab3GLRvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:51:13 -0400
Date: Fri, 12 Jul 2013 13:50:28 -0400
From: Dave Jones <davej@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
Message-ID: <20130712175028.GA11036@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Ahern <dsahern@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
References: <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
 <20130710154029.GB11309@redhat.com>
 <20130712103117.GA14862@gmail.com>
 <51E0230C.9010509@intel.com>
 <20130712154521.GD1020@redhat.com>
 <51E038ED.7050600@gmail.com>
 <20130712171808.GD1537@redhat.com>
 <51E03F76.3090607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E03F76.3090607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:40:06AM -0600, David Ahern wrote:
 > On 7/12/13 11:18 AM, Dave Jones wrote:
 > > On Fri, Jul 12, 2013 at 11:12:13AM -0600, David Ahern wrote:
 > >   > On 7/12/13 9:45 AM, Dave Jones wrote:
 > >   > > Here's a fun trick:
 > >   > >
 > >   > > trinity -c perf_event_open -C4 -q -l off
 > >   > >
 > 
 > In _get_address, case 8 must be happening a lot and I don't see a free 
 > when that address comes from malloc. Perhaps all of the rand() calls are 
 > breaking down in the VM. If I change that case from malloc to something 
 > static - like page_rand - memory stays flat.

Oh right, yeah, that's a known bug. I forgot about the ARG_ADDRESS case.
Another hacky workaround is to bound the trinity runs with -N1000000 or something
and do that in a shell loop so it frees it up on exit.

I need to find the time to add proper callbacks to release allocated memory.

Given you can run trinity long enough that you hit this however, makes me
think you won't be able to triger the bug I'm talking about.
Perhaps virtualised perf counters are somehow immune to this problem, because
on bare-metal, it literally takes seconds.

	Dave


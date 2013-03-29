Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3C2OZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:25:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33922 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3C2OZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:25:00 -0400
Date: Fri, 29 Mar 2013 15:25:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
Message-ID: <20130329142504.GA5374@nazgul.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Borislav Petkov <bp@suse.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <87d2uxje6u.fsf@sejong.aot.lge.com>
 <20130318084638.GC17959@gmail.com>
 <20130328155229.GP11449@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130328155229.GP11449@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 04:52:29PM +0100, Robert Richter wrote:
> An option would be to attach the persistent events to a hosting pmu
> (e.g. 'ras' in this case) and provide the events via sysfs as already
> done by other pmus:
> 
>  /sys/bus/event_source/devices/ras/events/
>  /sys/bus/event_source/devices/ras/events/mce_record
>  ...
> 
> perf tools work then out-the-box with -e ras/mce_record/.
> 
> The event is selected by the 'ras' pmu and then routed to the original
> pmu that might be e.g. 'tracepoint'. So we attach each persistent
> event to a 'virtual' pmu which does the grouping in the perf sysfs and
> the forwarding to its actual pmu.

As I told you already in IRC, persistent events should be completely
generic and not only related to ras. IOW, *all* possible events we have
now should be also be able to be created as persistent. What I mean is:

perf -e kvm:kvm_page_fault:P ... <target_task>

should mean that I want to collect *all* kvm page faulting events during
the system's lifetime not only during target_task executes.

And the "P" I've chosen arbitrary to mean persistent.

Which raises a couple more questions like what would happen with those
events once the perf tool call above exits. Obviously, the event should
stay enabled. Also, a subsequent call of this would mean "do not open
another persistent event of this type but give the persistent file
descriptor instead" and so on and so on.

Now, this probably can be solved with a virtual 'persistent' pmu which
'hosts' all persistent events. The question is, do we want to do it this
way?

What do the others think?

P.S. Btw, some of the concerns you've raised in your other mail have
been already addressed here:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git persistent5

and I'll look at the remaining ones when I get back.

Thanks.

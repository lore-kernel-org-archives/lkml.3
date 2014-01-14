Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaANQjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:53 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50098 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752263AbaANQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:48 -0500
Date: Tue, 14 Jan 2014 16:39:54 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3/11] issue 3: No understanding of potential cpu capacity
Message-ID: <20140114163953.GF3000@e103034-lin>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
 <3700155.hLuCBAXQoy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3700155.hLuCBAXQoy@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 09:07:12PM +0000, Rafael J. Wysocki wrote:
> On Tuesday, January 07, 2014 04:19:39 PM Morten Rasmussen wrote:
> > To minimize energy it may sometimes be better to put waking tasks on
> > partially loaded cpus instead of powering up more cpus (particularly if
> > it implies powering up a new cluster/group of cpus with associated
> > caches). To make that call, information about the potential spare cycles
> > on the busy cpus is required.
> 
> That generally is not the only thing that matters.  There's one more factor
> called "responsiveness" that used to be popular in the past.  It, roughly,
> is about how much time it takes for the system to respond to user actions,
> on the average.

Responsiveness is still very important. It is quite hard to control. CFS
doesn't consider latency. The only way to get the best responsiveness is
to go for best performance which comes at a high cost in energy.

IMHO, we are looking for ways to reduce energy without sacrificing too
much responsiveness, but we can't really guarantee the impact without
having latency awareness in the scheduler. I don't think it is feasible
to introduce that, so we have to do the best we can with whatever
heuristics we can come up with.

> 
> > Currently, the CFS scheduler has no knowledge about frequency scaling.
> > Frequency scaling governors generally try to match the frequency to
> > the load, which means that the idle time has no absolute meaning. The
> > potential spare cpu capacity may be much higher than indicated by the
> > idle time if the cpu is running at a low P-state.
> > 
> > The energy trade-off may justify putting another task on a loaded cpu
> > even if it causes a change to a higher P-state to handle the extra load.
> > Related issues are frequency (and cpu micro architecture) invariant task
> > load and power topology information, which are both needed to enable the
> > scheduler for energy-aware task placement. This is covered in more
> > detail in issue 5.
> > 
> > The potential cpu capacity cannot be assumed to be constant as thermal
> > management may restrict the usage of high performance P-states
> > dynamically.
> 
> That's correct.  Moreover, all of the above seems to assume that we can get
> exact power numbers for all of the involved C-states and P-states.  What if
> we can't?

None of the current load-tracking in the scheduler is exact or even
accurate. As long as we can get some hints it is better than nothing.

Morten

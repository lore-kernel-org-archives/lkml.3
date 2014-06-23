Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaFWOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:16:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:27759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaFWOQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="561900392"
Date: Mon, 23 Jun 2014 07:16:26 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140623141626.GB8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
 <20140619201801.GV8178@tassilo.jf.intel.com>
 <CABPqkBRy=u6oyyFV9yC9uOykHbNUdDqDgeQ3XSTpcAfQAyS-+g@mail.gmail.com>
 <20140619204041.GW8178@tassilo.jf.intel.com>
 <20140623073500.GJ19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623073500.GJ19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 09:35:00AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 19, 2014 at 01:40:41PM -0700, Andi Kleen wrote:
> > On Thu, Jun 19, 2014 at 10:31:29PM +0200, Stephane Eranian wrote:
> > > On Thu, Jun 19, 2014 at 10:18 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > > >> I don't quite understand that.
> > > >> You need to know which events support PEBS. You need a table
> > > >
> > > > We're talking about the kernel allowing things here.
> > > > Yes the user still needs to know what supports PEBS, but
> > > > that doesn't concern the kernel.
> > > >
> > > Just need to make sure you don't return bogus information.
> > 
> > GIGO. We only need to prevent security issues.
> 
> > Yes if the user specifies a bogus raw event it will not count.
> > That's fine. The important part is just that nothing ever crashes.
> 
> Right. But IIRC you were previously arguing that we can in fact crash
> the machine with raw PEBS events, as illustrated with the SNB PEBS
> cycles 'event'.

The potential problem could only happen for a recognized PEBS event/umask,
but with unsupported flag combinations. That is what the SDM warns
about in 18.8.4.

If the event is not recognized as PEBS it will just effectively 
disable the event.

> Which is where my strict_pebs patch came from; by default only allow the
> sanitized known-safe list of events, but allow the system administrator
> to disable that test and allow any PEBS event.

I don't think we need to enforce the list of events
(except for the few with special limited counters)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

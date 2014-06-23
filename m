Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaFWHfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:35:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFWHfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:35:07 -0400
Date: Mon, 23 Jun 2014 09:35:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140623073500.GJ19860@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
 <20140619201801.GV8178@tassilo.jf.intel.com>
 <CABPqkBRy=u6oyyFV9yC9uOykHbNUdDqDgeQ3XSTpcAfQAyS-+g@mail.gmail.com>
 <20140619204041.GW8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619204041.GW8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:40:41PM -0700, Andi Kleen wrote:
> On Thu, Jun 19, 2014 at 10:31:29PM +0200, Stephane Eranian wrote:
> > On Thu, Jun 19, 2014 at 10:18 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > >> I don't quite understand that.
> > >> You need to know which events support PEBS. You need a table
> > >
> > > We're talking about the kernel allowing things here.
> > > Yes the user still needs to know what supports PEBS, but
> > > that doesn't concern the kernel.
> > >
> > Just need to make sure you don't return bogus information.
> 
> GIGO. We only need to prevent security issues.

> Yes if the user specifies a bogus raw event it will not count.
> That's fine. The important part is just that nothing ever crashes.

Right. But IIRC you were previously arguing that we can in fact crash
the machine with raw PEBS events, as illustrated with the SNB PEBS
cycles 'event'.

Which is where my strict_pebs patch came from; by default only allow the
sanitized known-safe list of events, but allow the system administrator
to disable that test and allow any PEBS event.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbaFSUlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:41:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:10285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934365AbaFSUlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="447684311"
Date: Thu, 19 Jun 2014 13:40:41 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140619204041.GW8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
 <20140619201801.GV8178@tassilo.jf.intel.com>
 <CABPqkBRy=u6oyyFV9yC9uOykHbNUdDqDgeQ3XSTpcAfQAyS-+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRy=u6oyyFV9yC9uOykHbNUdDqDgeQ3XSTpcAfQAyS-+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:31:29PM +0200, Stephane Eranian wrote:
> On Thu, Jun 19, 2014 at 10:18 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >> I don't quite understand that.
> >> You need to know which events support PEBS. You need a table
> >
> > We're talking about the kernel allowing things here.
> > Yes the user still needs to know what supports PEBS, but
> > that doesn't concern the kernel.
> >
> Just need to make sure you don't return bogus information.

GIGO. We only need to prevent security issues.

> > You can just allow it for all, it's a nop if the event doesn't
> > support it. And also the fields like DataLA are simply 0 when
> > not supported.
> >
> 
> Let's take a example. If I do resource_stalls:pp, the kernel
> will let it go through and clear the PMI bit on the config as
> is required for PEBS mode. The counter will count normally
> and never fire an interrupt, even when it overflows. It would
> never execute the PMI handler and thus never look at the
> PEBS content. You'd never get any samples.

Yes if the user specifies a bogus raw event it will not count.
That's fine. The important part is just that nothing ever crashes.

-Andi

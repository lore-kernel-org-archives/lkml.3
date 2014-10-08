Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaJHK2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:28:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47738 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaJHK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:28:03 -0400
Date: Wed, 8 Oct 2014 11:27:58 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 04/11] perf: Make perf_cgroup_from_task() global
Message-ID: <20141008102758.GN14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-5-git-send-email-matt@console-pimps.org>
 <20141007185157.GA4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007185157.GA4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct, at 08:51:57PM, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:08PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > Move perf_cgroup_from_task() from kernel/events to include/ along with
> > the necessary struct definitions, so that it can be used by the PMU
> > code.
> > 
> > The upcoming Intel Cache Monitoring PMU driver assigns monitoring IDs
> > based on a task's association with a cgroup - all tasks in the same
> > cgroup share an ID. We can use perf_cgroup_from_task() to track this
> > association.
> 
> Not yet having read the rest of the patches and maybe understanding
> things wrong, that doesn't sound right.
> 
> The RMID should be associated with events, not groups. The event can be
> associated with whatever perf provides {task, cgroup, cpu}.

I think I just wrote the commit message in a goofy way.

What we actually use perf_cgroup_from_task() for is to figure out when
to prohibit an event from being created if it overlaps/conflicts with an
existing event.

I'll rewrite the commit message to be clearer.

-- 
Matt Fleming, Intel Open Source Technology Center

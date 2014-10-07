Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaJGSwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:52:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaJGSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:52:05 -0400
Date: Tue, 7 Oct 2014 20:51:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 04/11] perf: Make perf_cgroup_from_task() global
Message-ID: <20141007185157.GA4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-5-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-5-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:08PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Move perf_cgroup_from_task() from kernel/events to include/ along with
> the necessary struct definitions, so that it can be used by the PMU
> code.
> 
> The upcoming Intel Cache Monitoring PMU driver assigns monitoring IDs
> based on a task's association with a cgroup - all tasks in the same
> cgroup share an ID. We can use perf_cgroup_from_task() to track this
> association.

Not yet having read the rest of the patches and maybe understanding
things wrong, that doesn't sound right.

The RMID should be associated with events, not groups. The event can be
associated with whatever perf provides {task, cgroup, cpu}.

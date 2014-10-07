Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaJGTnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:43:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaJGTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:43:14 -0400
Date: Tue, 7 Oct 2014 21:43:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20141007194310.GC4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-9-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:12PM +0100, Matt Fleming wrote:
> +/*
> + * Determine if @a and @b measure the same set of tasks.
> + */
> +static bool __match_event(struct perf_event *a, struct perf_event *b)
> +{
> +	if ((a->attach_state & PERF_ATTACH_TASK) !=
> +	    (b->attach_state & PERF_ATTACH_TASK))
> +		return false;
> +
> +	/* not task */
> +
> +	return true; /* if not task, we're machine wide */
> +}

You cut too much out there. That first test checks weather the two
events are of the same type; ie. both tasks or both cpu. After that you
still need to verify that they are indeed the same target.



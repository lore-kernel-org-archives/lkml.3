Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaJGTe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:34:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaJGTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:34:27 -0400
Date: Tue, 7 Oct 2014 21:34:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/11] perf: Move cgroup init before PMU ->event_init()
Message-ID: <20141007193424.GB4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-7-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-7-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:10PM +0100, Matt Fleming wrote:
> +++ b/kernel/events/core.c
> @@ -6859,7 +6859,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  		 struct perf_event *group_leader,
>  		 struct perf_event *parent_event,
>  		 perf_overflow_handler_t overflow_handler,
> -		 void *context)
> +		 void *context, bool cgroup, pid_t pid)
>  {
>  	struct pmu *pmu;
>  	struct perf_event *event;

I don't get this extension, why a bool and pid_t ?

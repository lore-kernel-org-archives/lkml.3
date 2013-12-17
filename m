Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3LQUlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:41:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab3LQUlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:41:45 -0500
Message-ID: <52B0B6FF.7000507@redhat.com>
Date: Tue, 17 Dec 2013 15:41:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Timothy Strauss <david@davidstrauss.net>
CC: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: NUMA, migrate/N, and tuned-adm
References: <CAKz8sYWmmmdwKTKUGdoyaMD_v9_7yQydG+UNAb2r-KoO4L+6Ng@mail.gmail.com>
In-Reply-To: <CAKz8sYWmmmdwKTKUGdoyaMD_v9_7yQydG+UNAb2r-KoO4L+6Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 01:10 PM, David Timothy Strauss wrote:

> System specs:
>  * Fedora 19 with the 3.11.10-200.fc19.x86_64 kernel (just the stock RPM)
>  * Bare-metal servers with 128GB RAM split between two NUMA regions,
> each region with one hex-core processor
>  * More than 700 processes, a couple hundred of which are active
> fairly frequently. The systems were at 7000 processes, but we've
> dropped it while we dive into this issue.
>  * Many of the processes are short-lived. The long-lived ones
> experience spikes in CPU and memory usage while processing requests.
> 
> Here's what we've tried, to no avail:
>  * tuned-adm on latency-performance and virtual-host profiles; this
> places the system on the deadline scheduler, but this problem occurred
> on the default one too
>  * kernel.sched_migration_cost_ns=5000000 (which tuned will do for
> those profiles in v3.3/Fedora 20)
>  * numad to balance between regions
>  * Global use of sched_relax_domain_level=1 and sched_relax_domain_level=2
>  * Splitting the system with cpuset into management tasks (6 virtual
> cores) and workload tasks (18 virtual cores) with
> sched_relax_domain_level=2. This is based on recommendations for NUMA
> systems in the cpuset man page.

Just for a quick sanity check, can you try disabling the
automatic numa balancing code?

# echo NO_NUMA > /sys/kernel/debug/sched_features

> Here's what we've used for analysis:
>  * powertop
>  * top/htop
>  * perf record -a -g

Does "perf report -g" show where the calls to the
migration code are coming from? Something must be
migrating tasks around, and it will be good to know
what it is...

-- 
All rights reversed

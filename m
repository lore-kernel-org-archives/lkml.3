Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaAFLI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:08:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaAFLIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:08:24 -0500
Date: Mon, 6 Jan 2014 12:08:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140106110803.GA5623@twins.programming.kicks-ass.net>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 12:34:41PM -0800, Peter P Waskiewicz Jr wrote:
> The CPU features themselves are relatively straight-forward, but
> the presentation of the data is less straight-forward.  Since this
> tracks cache usage and occupancy per process (by swapping Resource
> Monitor IDs, or RMIDs, when processes are rescheduled), perf would
> not be a good fit for this data, which does not report on a
> per-process level.  Therefore, a new cgroup subsystem, cacheqos, has
> been added.  This operates very similarly to the cpu and cpuacct
> cgroup subsystems, where tasks can be grouped into sub-leaves of the
> root-level cgroup.

This doesn't make any sense.. From a quick SDM read you can do pretty
much whatever with those RMIDs. If you allocate a RMID per task (thread
in userspace) you can actually measure things on a task basis.

>From then on you can use perf-cgroup to group whatever tasks you want.

So please be more explicit in why you think this doesn't fit into perf.

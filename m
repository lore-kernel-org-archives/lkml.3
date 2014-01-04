Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaADQK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 11:10:57 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:62057 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaADQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 11:10:55 -0500
Date: Sat, 4 Jan 2014 11:10:50 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140104161050.GA24306@htj.dyndns.org>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

I don't really understand why this is implemented as part of cgroup.
There doesn't seem to be anything which requires cgroup.  Wouldn't
just doing it per-process make more sense?  Even grouping would be
better done along the traditional process hierarchy, no?  And
per-cgroup accounting can be trivially achieved from userland by just
accumulating the stats according to the process's cgroup membership.
What am I missing here?

Thanks.

-- 
tejun

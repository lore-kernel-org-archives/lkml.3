Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaAFQmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:42:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:2675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaAFQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:42:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="434565928"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Topic: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp4E7iAgABdYwA=
Date: Mon, 6 Jan 2014 16:42:29 +0000
Message-ID: <1389026538.32504.11.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
	 <20140106110803.GA5623@twins.programming.kicks-ass.net>
In-Reply-To: <20140106110803.GA5623@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.231]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D57DD7440A0D04186515BF31508FF8E@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06Gga7b007979

On Mon, 2014-01-06 at 12:08 +0100, Peter Zijlstra wrote:
> On Fri, Jan 03, 2014 at 12:34:41PM -0800, Peter P Waskiewicz Jr wrote:
> > The CPU features themselves are relatively straight-forward, but
> > the presentation of the data is less straight-forward.  Since this
> > tracks cache usage and occupancy per process (by swapping Resource
> > Monitor IDs, or RMIDs, when processes are rescheduled), perf would
> > not be a good fit for this data, which does not report on a
> > per-process level.  Therefore, a new cgroup subsystem, cacheqos, has
> > been added.  This operates very similarly to the cpu and cpuacct
> > cgroup subsystems, where tasks can be grouped into sub-leaves of the
> > root-level cgroup.
> 
> This doesn't make any sense.. From a quick SDM read you can do pretty
> much whatever with those RMIDs. If you allocate a RMID per task (thread
> in userspace) you can actually measure things on a task basis.

Exactly.  An RMID can be assigned to a single task or a group of tasks.
Because the RMID is a hardware resource and is limited, the
implementation of using it is what we're really discussing here.  Our
approach is to either monitor per-task, or per group of tasks.

> From then on you can use perf-cgroup to group whatever tasks you want.
> 
> So please be more explicit in why you think this doesn't fit into perf.

I said this in my other reply to the other thread, but I'll ask again
because I'm not following.  I'm looking for information on perf-cgroup,
and I all see is a way to monitor CPU events for tasks in a cgroup (perf
-G option).

The other part I'm not seeing is how to control the RMIDs being
allocated across to different groups.  There may be 100 task groups to
monitor, but only 32 RMIDs.  So the RMIDs need to be handed out to
active tasks and then enabled, data extracted, then disabled.  That was
the intent of the cacheqos.monitor_cache knob.

The bottom line is I'm asking for a bit more information from you about
perf-cgroup, since it sounds like you see a fit for CQM here, and I'm
not seeing what you're looking at yet.  Any information is much
appreciated.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

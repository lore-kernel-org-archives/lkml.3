Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaAFV0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:26:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaAFV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:26:46 -0500
Date: Mon, 6 Jan 2014 22:26:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140106212623.GH30183@twins.programming.kicks-ass.net>
References: <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140104225058.GC24306@htj.dyndns.org>
 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106111624.GB5623@twins.programming.kicks-ass.net>
 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106180636.GG30183@twins.programming.kicks-ass.net>
 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 08:10:45PM +0000, Waskiewicz Jr, Peter P wrote:
> There is one per logical CPU.  However, in the current generation, they
> report on the usage of the same L3 cache.  But the CPU takes care of the
> resolution of which MSR write and read comes from the logical CPU, so
> software doesn't need to lock access to it from different CPUs.

What are the rules of RMIDs, I can't seem to find that in the SDM and I
think you're tagging cachelines with them. Which would mean that in
order to (re) use them you need a complete cache (L3) wipe.

Without a wipe you keep having stale entries of the former user and no
clear indication on when your numbers are any good.

Also, is there any sane way of shooting down the entire L3?

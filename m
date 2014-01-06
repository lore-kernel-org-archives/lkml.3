Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaAFRyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:54:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37174 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaAFRyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:54:03 -0500
Date: Mon, 6 Jan 2014 18:53:38 +0100
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
Message-ID: <20140106175338.GF30183@twins.programming.kicks-ass.net>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
 <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140104225058.GC24306@htj.dyndns.org>
 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106111624.GB5623@twins.programming.kicks-ass.net>
 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:47:57PM +0000, Waskiewicz Jr, Peter P wrote:
> > Yeah that's not accurate, nor desired I think, because you get into
> > horrible problems with hierarchies, do child groups belong to your RMID
> > or not?
> 
> I'd rather not support a child group of a child group.  Only groups off
> the root, and each group would be assigned an RMID when it's activated
> for monitoring.

Yeah, that's a complete non started for cgroups. Cgroups need to be
completely hierarchical.

So even the root group should represent all tasks; which if you fragment
RMIDs on child cgroups doesn't work anymore.

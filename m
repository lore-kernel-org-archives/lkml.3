Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaJGPuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:50:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:48311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaJGPut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:50:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,671,1406617200"; 
   d="scan'208";a="601822301"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: RE: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Thread-Topic: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Thread-Index: AQHPzQDkPZQyOKBBqke6qipRRbb+cpwP48SAgBQxgmCAAFAaAIAAh92Q
Date: Tue, 7 Oct 2014 15:50:45 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016110CE@SHSMSX103.ccr.corp.intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-12-git-send-email-kan.liang@intel.com>
 <20140924141507.GF2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F98C@SHSMSX103.ccr.corp.intel.com>
 <20141007152412.GC5850@twins.programming.kicks-ass.net>
In-Reply-To: <20141007152412.GC5850@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > So I don't like this. Why not use the regular
> > > PERF_SAMPLE_BRANCH_STACK output to generate the stuff from? We
> > > already have two different means, with different transport, for callchains
> anyhow, so a third really won't matter.
> >
> > I'm not sure what you mean by using the regular
> > PERF_SAMPLE_BRANCH_STACK output to generate the stuff from.  But we
> > don't need to modify various architectures' perf_callchain_user, if
> > that's your concern.  An alternative way is to generate the callchain
> > output in a higher level, like perf_callchain.  If there is no frame
> > pointer, the entry->nr will be set to MAX+1. So  the perf_callchain
> > knows that we need to try LBR callstack if possible.  In
> > perf_callchain, it resets entry->nr to old value, and call
> > perf_callchain_lbr_callstack to check and fill the callchain struct if
> > possible.  The patch is as below.
> 
> Please instruct your MUA to wrap at 78 chars.
> 
> What I meant was: why can't we use the regular
> PERF_SAMPLE_BRANCH_STACK output to generate user traces from?
> 
> PERF_SAMPLE_BRANCH_STACK is the 'normal' LBR output format.

The data is originally from br_stack which is LBR format.
What the patch did is to convert it to CALLCHAIN output format in kernel.
So you'd like to let the kernel pass the LBR output format data to user space
perf tool,  and let perf tool to generate the callchain information?


Kan

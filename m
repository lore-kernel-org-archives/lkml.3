Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaLVNe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:34:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:55003 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbaLVNe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:34:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="502611112"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 1/1] perf, x86: bug fix for cycles:p and cycles:pp on SLM
Thread-Topic: [PATCH 1/1] perf, x86: bug fix for cycles:p and cycles:pp on
 SLM
Thread-Index: AQHQEzN8KpL5jVEeXEKEWSejF74iypyQSS4AgAtmiKA=
Date: Mon, 22 Dec 2014 13:34:33 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770168FDA5@SHSMSX103.ccr.corp.intel.com>
References: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
 <20141215152150.GB29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141215152150.GB29390@twins.programming.kicks-ass.net>
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


> 
> On Mon, Dec 08, 2014 at 06:27:43AM -0800, kan.liang@intel.com wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > @@ -568,8 +568,8 @@ struct event_constraint
> > intel_atom_pebs_event_constraints[] = {  };
> >
> >  struct event_constraint intel_slm_pebs_event_constraints[] = {
> > -	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> > -	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> > +	/* INST_RETIRED.ANY_P */
> > +	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1),
> 
> Should that not be:
> 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),
> 
> instead?

No, please refer to Table 19-20 in 19.10 Vol. 3 of SDM.
PEBS is only supported with PMC0.
There is no requirement to set inv and cmask.

Thanks,
Kan

> 
> >  	/* Allow all events as PEBS with no flags */
> >  	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
> >  	EVENT_CONSTRAINT_END
> > --
> > 1.8.3.1
> >

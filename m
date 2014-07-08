Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaGHOUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:20:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:36108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaGHOUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="558858124"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Thread-Topic: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Thread-Index: AQHPminNzOpbLO3T9E6R7RvweHK0aZuVYpqAgADLh0A=
Date: Tue, 8 Jul 2014 14:20:48 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014CDF5C@SHSMSX103.ccr.corp.intel.com>
References: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
 <20140708092513.GB6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140708092513.GB6758@twins.programming.kicks-ass.net>
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
> On Mon, Jul 07, 2014 at 06:34:25AM -0700, kan.liang@intel.com wrote:
> > +	/*
> > +	 * Access LBR MSR may cause #GP under certain circumstances.
> > +	 * E.g. KVM doesn't support LBR MSR
> > +	 * Check all LBT MSR here.
> > +	 * Disable LBR access if any LBR MSRs can not be accessed.
> > +	 */
> > +	if (x86_pmu.lbr_nr) {
> > +		x86_pmu.lbr_msr_access = check_msr(x86_pmu.lbr_tos);
> > +		for (i = 0; i < x86_pmu.lbr_nr; i++) {
> > +			x86_pmu.lbr_msr_access &=
> > +				check_msr(x86_pmu.lbr_from + i);
> > +			x86_pmu.lbr_msr_access &=
> > +				check_msr(x86_pmu.lbr_to + i);
> > +		}
> > +	}
> 
> So I was going to refer you to an email I send earlier telling you that this was
> wrong, but then found it got stuck in a mailqueue on my laptop :-(
> 
> In any case its wrong; just clear lbr_nr and kill lbr_msr_access. We already
> check lbr_nr in all the right places and you added lbr_msr_access to far too
> few of them (also the fact that every place you check lbr_msr_access already
> had an lbr_nr test should've been a clue).

OK. If lbr_nr is well checked at runtime, I will simply set lbr_nr to 0 here (once check_msr failed).

Thanks,
Kan 


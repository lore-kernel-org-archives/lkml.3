Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaKEREf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:04:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:25793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbaKEREc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:04:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="617662787"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Thread-Topic: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Thread-Index: AQHP+KX2mQc4+JvE8EymwJ/+bhfdO5xRQPaAgADzn3D//37EgIAAh4Mg
Date: Wed, 5 Nov 2014 17:02:48 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701654523@SHSMSX103.ccr.corp.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <20141105093759.GQ10501@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770165410A@SHSMSX103.ccr.corp.intel.com>
 <20141105162723.GW3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141105162723.GW3337@twins.programming.kicks-ass.net>
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



> On Wed, Nov 05, 2014 at 04:22:09PM +0000, Liang, Kan wrote:
> >
> > >>
> > >
> > > So if I take all except 11,13,16,17 but instead do something like
> > > the below, everything will work just fine, right?
> > >
> > > Or am I missing something?
> > >
> >
> > Yes, it should work.  Then LBR callstack will rely on user to enable it.
> > But user never get the LBR callstack data if it's available.
> > I'm not sure why you do that?
> 
> Uhm what? If you request PERF_SAMPLE_BRANCH_CALL_STACK the user
> will get the data through the regular PERF_SAMPLE_BRANCH_STACK
> output of PERF_RECORD_SAMPLE, right?

OK, I think I should understand your meaning.
>From the kernel side, we provide a 3rd callchain option to user.
The kernel only tries to enable LBR and prepare the data if possible.
The kernel doesn't guarantee the data must come from hardware LBR,
even user choose LBR callchain option. 

It's user tool's responsibility to filter the request, choose the data source
and reconstruct the data. It's not the scope of this kernel patch. That
should depend on the implementation of another user tool patchset.

What do you think?

Thanks,
Kan

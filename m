Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaKSNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:37:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:58312 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbaKSNhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:37:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="624869816"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Topic: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Index: AQHQA743cQ1rb+Jn4kS+6OT1ok92KZxn81Zw
Date: Wed, 19 Nov 2014 13:37:01 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701671C4D@SHSMSX103.ccr.corp.intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-4-git-send-email-kan.liang@intel.com>
	<87d28lqb35.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F077016711F9@SHSMSX103.ccr.corp.intel.com>
 <874mtvraop.fsf@sejong.aot.lge.com>
In-Reply-To: <874mtvraop.fsf@sejong.aot.lge.com>
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
> On Tue, 18 Nov 2014 14:01:06 +0000, Kan Liang wrote:
> >> On Fri, 14 Nov 2014 08:44:12 -0500, kan liang wrote:
> >> > +		/* LBR only affects the user callchain */
> >> > +		if (i != chain_nr) {
> >> > +			struct branch_stack *lbr_stack = sample-
> >> >branch_stack;
> >> > +			int lbr_nr = lbr_stack->nr;
> >> > +			/*
> >> > +			 * LBR callstack can only get user call chain.
> >> > +			 * The mix_chain_nr is kernel call chain
> >> > +			 * number plus LBR user call chain number.
> >> > +			 * i is kernel call chain number,
> >> > +			 * 1 is PERF_CONTEXT_USER,
> >> > +			 * lbr_nr + 1 is the user call chain number.
> >> > +			 * For details, please refer to the comments
> >> > +			 * in callchain__printf
> >> > +			 */
> >> > +			int mix_chain_nr = i + 1 + lbr_nr + 1;
> >> > +
> >> > +			if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
> >> > +				pr_warning("corrupted callchain.
> >> skipping...\n");
> >> > +				return 0;
> >> > +			}
> >>
> >> I'm not sure whether this is really a corrupted callchain.  If a
> >> single chain is greater than the max it should be corrupted, but
> >> we're now summing up with other values..
> >>
> >> What about checking callchain_nr and lbr_nr separately or mix_nr with
> >> 2*max?
> >
> > The lbr_nr max is 16. I will change it to max+16.
> 
> Shouldn't it be 18 (16 + 1 + 1) at least?

In the new patch, I use PERF_MAX_BRANCH_DEPTH from Andi's patch. It's
127. It should be enough.

 +		if (mix_chain_nr > PERF_MAX_STACK_DEPTH +
 PERF_MAX_BRANCH_DEPTH) {
 +			pr_warning("corrupted callchain. skipping...\n");
 +			return 0;
 +		}

Thanks,
Kan
> 
> Thanks,
> Namhyung

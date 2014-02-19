Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaBSPmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:42:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:8264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaBSPmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:42:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,506,1389772800"; 
   d="scan'208";a="477723894"
Date: Wed, 19 Feb 2014 07:40:36 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: x86 perf's dTLB-load-misses broken on IvyBridge? II
Message-ID: <20140219154036.GX12219@tassilo.jf.intel.com>
References: <5303E8BF.9030107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303E8BF.9030107@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  [ C(DTLB) ] = {
> >         [ C(OP_READ) ] = {
> >                 [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
> >                 [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> >         },


Actually I tested on the wrong system earlier, sorry The miss event code 
is wrong on IvyBridge, it should be 0x8108 (DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK),
not 0x0108.

BTW that event only counts demand loads, no prefetches, that would be a separate event.

dTLB-loads works with and without PEBS.


-Andi

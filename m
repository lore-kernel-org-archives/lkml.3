Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaDYNSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:18:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:1257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaDYNSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="528296777"
Message-ID: <535A6070.90803@intel.com>
Date: Fri, 25 Apr 2014 21:17:36 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com> <20140418105354.GA29167@gmail.com> <53548008.3040504@intel.com> <20140422113545.GA14950@gmail.com> <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com> <20140424081408.GA7709@gmail.com> <5358E6A2.3020505@intel.com> <CABPqkBRihMr=+X_Gb5dSYfForTpGA6XZGfTHOA3PZNAHTJDPkg@mail.gmail.com> <20140424112715.GQ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140424112715.GQ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 07:27 PM, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 12:36:01PM +0200, Stephane Eranian wrote:
>>> Most of hardware specific codes in the Intel uncore driver are for
>>> SandyBridge/IvyBridge/Haswell. Uncore subsystem in these CPUs are
>>> similar. One module per CPU type means we have to duplicate lots of
>>> code. I don't think it's a good idea.
>>>
>> Then, at least split nhm_ex from the rest. It is very big.
> 
> Aren't the EX parts in general far more complex and different from the
> EP parts? Or will the SNB/IVB/HSW-EX parts also be similar again? (this
> would be a good thing).

SNB/IVB/HSW-EX are almost identical to SNB/IVB/HSW-EP. NHM/WSM-EX are complete
different from SNB/IVB/HSW-EX

Regards
Yan, Zheng


> 
> But yes, it makes sense to at least split the EP and EX parts, and split
> where the families are different.
> 


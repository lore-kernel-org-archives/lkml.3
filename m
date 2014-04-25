Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDYNz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:55:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaDYNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:55:55 -0400
Date: Fri, 25 Apr 2014 15:55:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140425135549.GF11096@twins.programming.kicks-ass.net>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
 <20140418105354.GA29167@gmail.com>
 <53548008.3040504@intel.com>
 <20140422113545.GA14950@gmail.com>
 <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com>
 <20140424081408.GA7709@gmail.com>
 <5358E6A2.3020505@intel.com>
 <CABPqkBRihMr=+X_Gb5dSYfForTpGA6XZGfTHOA3PZNAHTJDPkg@mail.gmail.com>
 <20140424112715.GQ11096@twins.programming.kicks-ass.net>
 <535A6070.90803@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A6070.90803@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:17:36PM +0800, Yan, Zheng wrote:
> On 04/24/2014 07:27 PM, Peter Zijlstra wrote:
> > On Thu, Apr 24, 2014 at 12:36:01PM +0200, Stephane Eranian wrote:
> >>> Most of hardware specific codes in the Intel uncore driver are for
> >>> SandyBridge/IvyBridge/Haswell. Uncore subsystem in these CPUs are
> >>> similar. One module per CPU type means we have to duplicate lots of
> >>> code. I don't think it's a good idea.
> >>>
> >> Then, at least split nhm_ex from the rest. It is very big.
> > 
> > Aren't the EX parts in general far more complex and different from the
> > EP parts? Or will the SNB/IVB/HSW-EX parts also be similar again? (this
> > would be a good thing).
> 
> SNB/IVB/HSW-EX are almost identical to SNB/IVB/HSW-EP.

Ah, good, sanity prevails!

> NHM/WSM-EX are complete different from SNB/IVB/HSW-EX

Yeah, NHM/WSM-EX are different from pretty much anything.

Where do NHM/WSM-EP fall? I know they're radically different to the EX
parts but are they similar again to the SNB/IVB/HSW EP parts?

If not we'd have 3 groups:

NHM/WSM-EP
NHM/WSM-EX
SNB/IVB/HSW

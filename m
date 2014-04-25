Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaDYOfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:35:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDYOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:35:07 -0400
Date: Fri, 25 Apr 2014 16:35:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140425143501.GH11096@twins.programming.kicks-ass.net>
References: <53548008.3040504@intel.com>
 <20140422113545.GA14950@gmail.com>
 <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com>
 <20140424081408.GA7709@gmail.com>
 <5358E6A2.3020505@intel.com>
 <CABPqkBRihMr=+X_Gb5dSYfForTpGA6XZGfTHOA3PZNAHTJDPkg@mail.gmail.com>
 <20140424112715.GQ11096@twins.programming.kicks-ass.net>
 <535A6070.90803@intel.com>
 <20140425135549.GF11096@twins.programming.kicks-ass.net>
 <535A6BD7.4090709@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A6BD7.4090709@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:06:15PM +0800, Yan, Zheng wrote:
> the uncore driver does not support NHM/WSM-EP (I don't know the module numbers for NHM/WSM-EP, maybe I'm wrong)

My wsm-ep has /sys/bus/event_source/devices/uncore so I suppose the
driver loaded. Its model 44 fwiw.

Also, from the uncore driver:

	switch (boot_cpu_data.x86_model) {
	case 26: /* Nehalem */
	case 30:
	case 37: /* Westmere */
	case 44:
		msr_uncores = nhm_msr_uncores;
		break;

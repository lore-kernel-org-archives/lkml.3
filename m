Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaDXIOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:14:19 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53695 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaDXIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:14:12 -0400
Date: Thu, 24 Apr 2014 10:14:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140424081408.GA7709@gmail.com>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
 <20140418105354.GA29167@gmail.com>
 <53548008.3040504@intel.com>
 <20140422113545.GA14950@gmail.com>
 <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> >> Most of the codes without comments are hardware specific codes. 
> >> The corresponding contents in Intel uncore documents are big 
> >> tables/lists, nothing tricky/interesting. I really don't know how 
> >> to comment these code.
> >
> > Have a look at other PMU drivers, such as
> > arch/x86/kernel/cpu/perf_event_intel_rapl.c, which begin with a
> > general explanation attached below.
>
> I think a more useful modularization would be to split that huge 
> file (perf_event_intel_uncore.c) into smaller files like we do for 
> the core PMU. There is just too much stuff in this file for my own 
> taste. Hard to navigate and I spend quite some time looking at it 
> and modifying it!
> 
> You could follow the model of the core PMU support files.
> You'd have a "core" file with the common routines, and then
> a file perf processor:
>     - perf_event_intel_uncore.c
>     - perf_event_intel_snbep_uncore.c
>     - perf_event_intel_nhmex_uncore.c
>     - perf_event_intel_ivt_uncore.c
>     - ...
> 
> Each processor specific module, would be a kernel module. The core 
> could be one too. Note that this would not alleviate the need for 
> some basic descriptions at the beginning of each file outlining the 
> PMU boxes exported to a minimum.

This structure you outline sounds like a good first step, I like it.

To simplify this restructuring, initially we could even keep the core 
uncore bits in the core (ha!), to not have module-on-module 
dependencies.

Thanks,

	Ingo

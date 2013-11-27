Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3K0WBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:01:19 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:60468 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959Ab3K0WBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:01:16 -0500
Date: Wed, 27 Nov 2013 17:03:35 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Stephane Eranian <eranian@google.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
In-Reply-To: <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy>
References: <1384275531-10892-1-git-send-email-eranian@google.com> <1384275531-10892-4-git-send-email-eranian@google.com> <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy> <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.52966BAC.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Stephane Eranian wrote:

> On Wed, Nov 27, 2013 at 7:35 PM, Vince Weaver <vince@deater.net> wrote:

> > So I notice PP1 (which is the GPU power on non-server chips)
> > is not supported.
> >
> > Is that just for simplicity?
> >
> Does it work on specific models only? I bet so. How to detect those?

In general it is on the machines that don't support the DRAM measurements 
(so the non-EP machines) but I don't know if there's a nice list anywhere.

Intel manuals say:
   For a client platform, PP1 domain refers to the power plane of a 
   specific device in the uncore. For server platforms, PP1 domain is not
   supported,

usually PP1 I think maps to the embedded GPU.

> > Sorry if these are annoying questions, I am glad to see this driver make
> > progress, as I've had the misfortune of maintaining various user-space-MSR
> > hacks designed to get this info because of lack of kernel support.
> >
> You don't really need a driver, you can also just use modprobe msr + the
> turbostat utility now part of the kernel source tree. It taps into the same
> counters.

yes, the code I maintain doesn't have a custom driver, it just uses the 
raw msr interface.  That's how PAPI currently works.  Though I guess I'll 
have to maintain both that and the new interface for a while as not 
everyone's going to run out and instlal 3.14.

It's a shame that it took so long for proper RAPL support to get merged.  
Because of the delay there are lots of people poking the MSRs themselves 
and various vendors who are shipping custom out-of-tree RAPL drivers, etc.

Vince

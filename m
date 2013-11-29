Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3K2TOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:14:33 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:36527 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753229Ab3K2TOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:14:31 -0500
Date: Fri, 29 Nov 2013 14:16:45 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Stephane Eranian <eranian@google.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
In-Reply-To: <CABPqkBSiLkDCcLFz5oxs2KS02LbiMNoAucrcx36aYqodiVpCpg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311291413430.13064@pianoman.cluster.toy>
References: <1384275531-10892-1-git-send-email-eranian@google.com> <1384275531-10892-4-git-send-email-eranian@google.com> <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy> <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
 <alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy> <20131128122619.GA6561@gmail.com> <CABPqkBSiLkDCcLFz5oxs2KS02LbiMNoAucrcx36aYqodiVpCpg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.5298E796.0111,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Stephane Eranian wrote:

> On Thu, Nov 28, 2013 at 1:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Vince Weaver <vince@deater.net> wrote:
> >
> >> On Wed, 27 Nov 2013, Stephane Eranian wrote:
> >>
> >> > On Wed, Nov 27, 2013 at 7:35 PM, Vince Weaver <vince@deater.net> wrote:
> >>
> >> > > So I notice PP1 (which is the GPU power on non-server chips)
> >> > > is not supported.
> >> > >
> >> > > Is that just for simplicity?
> >> > >
> >> > Does it work on specific models only? I bet so. How to detect those?
> >>
> >> In general it is on the machines that don't support the DRAM measurements
> >> (so the non-EP machines) but I don't know if there's a nice list anywhere.
> >>
> >> Intel manuals say:
> >>    For a client platform, PP1 domain refers to the power plane of a
> >>    specific device in the uncore. For server platforms, PP1 domain is not
> >>    supported,
> >>
> >> usually PP1 I think maps to the embedded GPU.
> >
> > It would indeed be nice to expose PP1 too via the same facility -
> > Haswell and later spends some 40% of the CPU die on the integrated GPU
> > and people end up using it.
> >
> My worry is to determine if the GPU is actually enabled or even present.
> Using the x86_model may not be enough for that.

In my experience if the device is not there you just get 0s as results
from RAPL (I've also seen this on some Sandybridge-EP machines we have 
that for whatever reason don't support the DRAM RAPL results).

So in theory it would be harmless to export the values even if not 
supported.  What is the worst failure mode?  That somehow a recent CPU 
doesn't support the MSR and we get a GPF when trying to access it?

Vince

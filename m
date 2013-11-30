Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3K3Qgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:36:49 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:51586 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788Ab3K3Qgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:36:48 -0500
Date: Sat, 30 Nov 2013 11:39:09 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Stephane Eranian <eranian@google.com>
cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
In-Reply-To: <CABPqkBRtBESMT-+FokR0+JYYL3Q=GUG-e5gZGOeHT3wOOtEaow@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311301135220.22019@pianoman.cluster.toy>
References: <1384275531-10892-1-git-send-email-eranian@google.com> <1384275531-10892-4-git-send-email-eranian@google.com> <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy> <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
 <alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy> <20131128122619.GA6561@gmail.com> <CABPqkBSiLkDCcLFz5oxs2KS02LbiMNoAucrcx36aYqodiVpCpg@mail.gmail.com> <alpine.DEB.2.02.1311291413430.13064@pianoman.cluster.toy> <CABPqkBTvhgXm_UNWDEgjP4aVf=G2MxfgBpnJBsiAZpcg7x-r=w@mail.gmail.com>
 <20131129203103.GJ4266@pd.tnic> <CABPqkBRtBESMT-+FokR0+JYYL3Q=GUG-e5gZGOeHT3wOOtEaow@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.529A141F.0082,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Stephane Eranian wrote:

> Ok, I have added PP1 now and it works fine on my HSW desktop.
> What I want to know now is what is this map to on servers?
> And on clients, it is always mapped to the GFX. If so, then
> we can use a more specific name: power/energy-gfx/

I don't know if it is documented well, but I get the impression that PP1 
is always graphics.

The turbostat code included with the kernel certainly thinks it is always 
graphics, it maps PP1 to "GFX"

The turbostat code also has a map of which chips have which features, 
although it seems to use internal Intel abbreviations that I don't 
necessarily follow (BYT? AVN?):


        switch (model) {
        case 0x2A:
        case 0x3A:
        case 0x3C:      /* HSW */
        case 0x3F:      /* HSW */
        case 0x45:      /* HSW */
        case 0x46:      /* HSW */
                do_rapl = RAPL_PKG | RAPL_CORES | RAPL_CORE_POLICY | 
RAPL_GFX | RAPL_PKG_POWER_INFO;
                break;
        case 0x2D:
        case 0x3E:
                do_rapl = RAPL_PKG | RAPL_CORES | RAPL_CORE_POLICY | 
RAPL_DRAM | RAPL_PKG_PERF_STATUS | RAPL_DRAM_PERF_STATUS | 
RAPL_PKG_POWER_INFO;
                break;
        case 0x37:      /* BYT */
        case 0x4D:      /* AVN */
                do_rapl = RAPL_PKG | RAPL_CORES ;
                break;
        default:
                return;
        }


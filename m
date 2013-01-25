Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3AYPrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:47:05 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:30136
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556Ab3AYPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:47:03 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -22
X-BigFish: VPS-22(z551biz98dI9371Ie6eL14e4M103dK1432Ib73dMzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch177df4h17326ah8275bh8275dh5eeeKz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH6UI2-01-6YI-02
X-M-MSG: 
Date: Fri, 25 Jan 2013 09:46:49 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: <eranian@gmail.com>
CC: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perfmon2] [PATCH RESEND V5 0/6] perf, amd: Enable AMD family
 15h northbridge counters
Message-ID: <20130125154648.GA25064@jshin-Toonie>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
 <CABPqkBS-cE3T6ccVDGtzgQBKM_bC9vugzWzP94ycYz4dWujp2g@mail.gmail.com>
 <20130124220634.GA20617@jshin-Toonie>
 <CAMsRxfLU6Y3TDz1fEZVsNAcO104AqtdNjZNHeVPyVpxpnSBdVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMsRxfLU6Y3TDz1fEZVsNAcO104AqtdNjZNHeVPyVpxpnSBdVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:42:57AM +0100, Stephane Eranian wrote:
> Hi Jacob,
> 
> I will apply this patch to libpfm4.
> But I have a question. Why aren't the other uncore
> events included here as well? I am talking about
> the events listed in BKDG sections 3.16.2 to 3.16.6?
> Are  those NOT supported by your kernel patchset?

Oh, you are right, they are supported. I'm not sure why I overlooked
them. I will send out a V2 that includes all of those events as well.

Sorry about that.

-Jacob

> 
> 
> On Thu, Jan 24, 2013 at 11:06 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > On Thu, Jan 24, 2013 at 02:31:59PM +0100, Stephane Eranian wrote:
> >> On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> >> > The following patchset enables 4 additional performance counters in
> >> > AMD family 15h processors that count northbridge events -- such as
> >> > number of DRAM accesses.
> >> >
> >> In order for me to test this patch set more thoroughly it would help if you
> >> could also provide me a patch to add the Fam15h uncore events to libpfm4.
> >> In the past, Robert Richter took care of this. I hope you can fill his role for
> >> this. So please, if you could send me the patch quickly, that would help
> >> the review of your patch.
> >
> > Hi Stephane,
> >
> > Here is the corresponding libpfm4 patch. Thank you for taking the time
> > to review the patchset. I hope this helps .. If we can get AMD related
> > perf kernel side patchsets to upstream, I will be more than happy to
> > support AMD related libpfm4 efforts going forward.
> >
> > Thanks!
> >
> > >From 47d3267dfa24b9071c76f4a22bd059b0e4032002 Mon Sep 17 00:00:00 2001
> > From: Jacob Shin <jacob.shin@amd.com>
> > Date: Thu, 24 Jan 2013 15:37:37 -0600
> > Subject: [PATCH 1/1] Add AMD Family 15h northbridge performance events
> >
> > libpfm4 side support for the following Linux kernel patchset:
> >   http://lkml.org/lkml/2013/1/10/450
> >
> > Reference -- BIOS and Kernel Developer Guide (BKDG) for AMD Family 15h
> >  Models 00h-0Fh Processors:
> >   http://support.amd.com/us/Processor_TechDocs/42301_15h_Mod_00h-0Fh_BKDG.pdf
> >
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  lib/events/amd64_events_fam15h.h |  155 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 155 insertions(+)
> >
> > diff --git a/lib/events/amd64_events_fam15h.h b/lib/events/amd64_events_fam15h.h
> > index 7f654e8..0276782 100644
> > --- a/lib/events/amd64_events_fam15h.h
> > +++ b/lib/events/amd64_events_fam15h.h
> > @@ -752,6 +752,126 @@ static const amd64_umask_t amd64_fam15h_l2_prefetcher_trigger_events[]={
> >     },
> >  };
> >
> > +static const amd64_umask_t amd64_fam15h_dram_accesses[]={
> > +   { .uname = "DCT0_PAGE_HIT",
> > +     .udesc = "DCT0 Page hit",
> > +     .ucode = 0x1,
> > +   },
> > +   { .uname = "DCT0_PAGE_MISS",
> > +     .udesc = "DCT0 Page Miss",
> > +     .ucode = 0x2,
> > +   },
> > +   { .uname = "DCT0_PAGE_CONFLICT",
> > +     .udesc = "DCT0 Page Conflict",
> > +     .ucode = 0x4,
> > +   },
> > +   { .uname = "DCT1_PAGE_HIT",
> > +     .udesc = "DCT1 Page hit",
> > +     .ucode = 0x8,
> > +   },
> > +   { .uname = "DCT1_PAGE_MISS",
> > +     .udesc = "DCT1 Page Miss",
> > +     .ucode = 0x10,
> > +   },
> > +   { .uname = "DCT1_PAGE_CONFLICT",
> > +     .udesc = "DCT1 Page Conflict",
> > +     .ucode = 0x20,
> > +   },
> > +   { .uname  = "ALL",
> > +     .udesc  = "All sub-events selected",
> > +     .ucode  = 0x3f,
> > +     .uflags = AMD64_FL_NCOMBO | AMD64_FL_DFL,
> > +   },
> > +};
> > +
> > +static const amd64_umask_t amd64_fam15h_dram_controller_page_table_overflows[]={
> > +   { .uname = "DCT0_PAGE_TABLE_OVERFLOW",
> > +     .udesc = "DCT0 Page Table Overflow",
> > +     .ucode = 0x1,
> > +   },
> > +   { .uname = "DCT1_PAGE_TABLE_OVERFLOW",
> > +     .udesc = "DCT1 Page Table Overflow",
> > +     .ucode = 0x2,
> > +   },
> > +   { .uname  = "ALL",
> > +     .udesc  = "All sub-events selected",
> > +     .ucode  = 0x3,
> > +     .uflags = AMD64_FL_NCOMBO | AMD64_FL_DFL,
> > +   },
> > +};
> > +
> > +static const amd64_umask_t amd64_fam15h_memory_controller_dram_command_slots_missed[]={
> > +   { .uname = "DCT0_COMMAND_SLOTS_MISSED",
> > +     .udesc = "DCT0 Command Slots Missed (in MemClks)",
> > +     .ucode = 0x1,
> > +   },
> > +   { .uname = "DCT1_COMMAND_SLOTS_MISSED",
> > +     .udesc = "DCT1 Command Slots Missed (in MemClks)",
> > +     .ucode = 0x2,
> > +   },
> > +   { .uname  = "ALL",
> > +     .udesc  = "All sub-events selected",
> > +     .ucode  = 0x3,
> > +     .uflags = AMD64_FL_NCOMBO | AMD64_FL_DFL,
> > +   },
> > +};
> > +
> > +static const amd64_umask_t amd64_fam15h_memory_controller_turnarounds[]={
> > +   { .uname = "DCT0_DIMM_TURNAROUND",
> > +     .udesc = "DCT0 DIMM (chip select) turnaround",
> > +     .ucode = 0x1,
> > +   },
> > +   { .uname = "DCT0_READ_TO_WRITE_TURNAROUND",
> > +     .udesc = "DCT0 Read to write turnaround",
> > +     .ucode = 0x2,
> > +   },
> > +   { .uname = "DCT0_WRITE_TO_READ_TURNAROUND",
> > +     .udesc = "DCT0 Write to read turnaround",
> > +     .ucode = 0x4,
> > +   },
> > +   { .uname = "DCT1_DIMM_TURNAROUND",
> > +     .udesc = "DCT1 DIMM (chip select) turnaround",
> > +     .ucode = 0x8,
> > +   },
> > +   { .uname = "DCT1_READ_TO_WRITE_TURNAROUND",
> > +     .udesc = "DCT1 Read to write turnaround",
> > +     .ucode = 0x10,
> > +   },
> > +   { .uname = "DCT1_WRITE_TO_READ_TURNAROUND",
> > +     .udesc = "DCT1 Write to read turnaround",
> > +     .ucode = 0x20,
> > +   },
> > +   { .uname  = "ALL",
> > +     .udesc  = "All sub-events selected",
> > +     .ucode  = 0x3f,
> > +     .uflags = AMD64_FL_NCOMBO | AMD64_FL_DFL,
> > +   },
> > +};
> > +
> > +static const amd64_umask_t amd64_fam15h_memory_controller_bypass_counter_saturation[]={
> > +   { .uname = "MEMORY_CONTROLLER_HIGH_PRIORITY_BYPASS",
> > +     .udesc = "Memory controller high priority bypass",
> > +     .ucode = 0x1,
> > +   },
> > +   { .uname = "MEMORY_CONTROLLER_MEDIUM_PRIORITY_BYPASS",
> > +     .udesc = "Memory controller medium priority bypass",
> > +     .ucode = 0x2,
> > +   },
> > +   { .uname = "DCT0_DCQ_BYPASS",
> > +     .udesc = "DCT0 DCQ bypass",
> > +     .ucode = 0x4,
> > +   },
> > +   { .uname = "DCT1_DCQ_BYPASS",
> > +     .udesc = "DCT1 DCQ bypass",
> > +     .ucode = 0x8,
> > +   },
> > +   { .uname  = "ALL",
> > +     .udesc  = "All sub-events selected",
> > +     .ucode  = 0xf,
> > +     .uflags = AMD64_FL_NCOMBO | AMD64_FL_DFL,
> > +   },
> > +};
> > +
> >  static const amd64_entry_t amd64_fam15h_pe[]={
> >  { .name    = "DISPATCHED_FPU_OPS",
> >    .desc    = "FPU Pipe Assignment",
> > @@ -1256,4 +1376,39 @@ static const amd64_entry_t amd64_fam15h_pe[]={
> >    .modmsk  = AMD64_FAM15H_ATTRS,
> >    .code    = 0x1d8,
> >  },
> > +{ .name    = "DRAM_ACCESSES",
> > +  .desc    = "DRAM Accesses",
> > +  .code    = 0xe0,
> > +  .numasks = LIBPFM_ARRAY_SIZE(amd64_fam15h_dram_accesses),
> > +  .ngrp    = 1,
> > +  .umasks  = amd64_fam15h_dram_accesses,
> > +},
> > +{ .name    = "DRAM_CONTROLLER_PAGE_TABLE_OVERFLOWS",
> > +  .desc    = "DRAM Controller Page Table Overflows",
> > +  .code    = 0xe1,
> > +  .numasks = LIBPFM_ARRAY_SIZE(amd64_fam15h_dram_controller_page_table_overflows),
> > +  .ngrp    = 1,
> > +  .umasks  = amd64_fam15h_dram_controller_page_table_overflows,
> > +},
> > +{ .name    = "MEMORY_CONTROLLER_DRAM_COMMAND_SLOTS_MISSED",
> > +  .desc    = "Memory Controller DRAM Command Slots Missed",
> > +  .code    = 0xe2,
> > +  .numasks = LIBPFM_ARRAY_SIZE(amd64_fam15h_memory_controller_dram_command_slots_missed),
> > +  .ngrp    = 1,
> > +  .umasks  = amd64_fam15h_memory_controller_dram_command_slots_missed,
> > +},
> > +{ .name    = "MEMORY_CONTROLLER_TURNAROUNDS",
> > +  .desc    = "Memory Controller Turnarounds",
> > +  .code    = 0xe3,
> > +  .numasks = LIBPFM_ARRAY_SIZE(amd64_fam15h_memory_controller_turnarounds),
> > +  .ngrp    = 1,
> > +  .umasks  = amd64_fam15h_memory_controller_turnarounds,
> > +},
> > +{ .name    = "MEMORY_CONTROLLER_BYPASS_COUNTER_SATURATION",
> > +  .desc    = "Memory Controller Bypass Counter Saturation",
> > +  .code    = 0xe4,
> > +  .numasks = LIBPFM_ARRAY_SIZE(amd64_fam15h_memory_controller_bypass_counter_saturation),
> > +  .ngrp    = 1,
> > +  .umasks  = amd64_fam15h_memory_controller_bypass_counter_saturation,
> > +},
> >  };
> > --
> > 1.7.9.5
> >
> >
> >
> > ------------------------------------------------------------------------------
> > Master Visual Studio, SharePoint, SQL, ASP.NET, C# 2012, HTML5, CSS,
> > MVC, Windows 8 Apps, JavaScript and much more. Keep your skills current
> > with LearnDevNow - 3,200 step-by-step video tutorials by Microsoft
> > MVPs and experts. ON SALE this month only -- learn more at:
> > http://p.sf.net/sfu/learnnow-d2d
> > _______________________________________________
> > perfmon2-devel mailing list
> > perfmon2-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/perfmon2-devel
> 


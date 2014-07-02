Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbaGBSO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:14:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:51975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbaGBSO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="537888257"
Date: Wed, 2 Jul 2014 11:10:14 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702181014.GP19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <CABPqkBT1XC=mG-ZhjAcMOksdCgP-p3TSSAefi7XBOajMugBYZQ@mail.gmail.com>
 <20140702153300.GM19781@tassilo.jf.intel.com>
 <CABPqkBQvSGA2k4eSHg54k3i8cTotviuvY71RuSc=Rh0iuxaPxg@mail.gmail.com>
 <20140702154828.GO19781@tassilo.jf.intel.com>
 <CABPqkBQ7x7-Ma2xJFKGBj3Nnsac1J_5PG9us6xgU1ES+WHkMUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ7x7-Ma2xJFKGBj3Nnsac1J_5PG9us6xgU1ES+WHkMUQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 06:07:31PM +0200, Stephane Eranian wrote:
> On Wed, Jul 2, 2014 at 5:48 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > On Wed, Jul 02, 2014 at 05:44:05PM +0200, Stephane Eranian wrote:
> >> On Wed, Jul 2, 2014 at 5:33 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >> >> No, still needs to be INTEL_ALL_EVENT_CONSTRAINT(0x0, 0x1)
> >> >> otherwise the get_event_constraint() test I mentioned previously will
> >> >> fail, event with your ALL_FILTER mask.
> >> >
> >> > What events should fail? I verified all PEBS events and they work as expected.
> >> >
> >> Random events should not fail, they should go with precise and not generate
> >> any samples. That's the whole point of the exercise.
> >>
> >> perf record -a -e r6099:p sleep 1
> >
> > Like I said I ran all PEBS events and they generated samples.
> >
> I understand. I ran some random events to make sure I was not
> getting PEBS samples and the system was stable.

Not sure we're talking about the same thing. You claimed my patch
wouldn't let any PEBS events through, but the test results 
disagree with that.

I fixed the broken store events you pointed out.

INST_RETIRED.PREC_DIST
cpu/event=0xC0,umask=0x01,name=INST_RETIRED_PREC_DIST/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.179 MB perf.data (~7821 samples) ]
UOPS_RETIRED.ALL
cpu/event=0xC2,umask=0x01,name=UOPS_RETIRED_ALL/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.179 MB perf.data (~7824 samples) ]
UOPS_RETIRED.RETIRE_SLOTS
cpu/event=0xC2,umask=0x02,name=UOPS_RETIRED_RETIRE_SLOTS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.180 MB perf.data (~7869 samples) ]
BR_INST_RETIRED.CONDITIONAL
cpu/event=0xC4,umask=0x01,name=BR_INST_RETIRED_CONDITIONAL/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.177 MB perf.data (~7729 samples) ]
BR_INST_RETIRED.NEAR_CALL
cpu/event=0xC4,umask=0x02,name=BR_INST_RETIRED_NEAR_CALL/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.140 MB perf.data (~6112 samples) ]
BR_INST_RETIRED.NEAR_RETURN
cpu/event=0xC4,umask=0x08,name=BR_INST_RETIRED_NEAR_RETURN/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.140 MB perf.data (~6124 samples) ]
BR_INST_RETIRED.NEAR_TAKEN
cpu/event=0xC4,umask=0x20,name=BR_INST_RETIRED_NEAR_TAKEN/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.176 MB perf.data (~7709 samples) ]
BR_INST_RETIRED.ALL_BRANCHES_PEBS
cpu/event=0xC4,umask=0x04,name=BR_INST_RETIRED_ALL_BRANCHES_PEBS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.177 MB perf.data (~7747 samples) ]
BR_MISP_RETIRED.CONDITIONAL
cpu/event=0xC5,umask=0x01,name=BR_MISP_RETIRED_CONDITIONAL/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.132 MB perf.data (~5767 samples) ]
BR_MISP_RETIRED.ALL_BRANCHES_PEBS
cpu/event=0xC5,umask=0x04,name=BR_MISP_RETIRED_ALL_BRANCHES_PEBS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.132 MB perf.data (~5781 samples) ]
HLE_RETIRED.ABORTED
cpu/event=0xc8,umask=0x04,name=HLE_RETIRED_ABORTED/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~86 samples) ]
RTM_RETIRED.ABORTED
cpu/event=0xc9,umask=0x04,name=RTM_RETIRED_ABORTED/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~86 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_4
cpu/event=0xCD,umask=0x01,ldlat=0x4,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_4/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.179 MB perf.data (~7832 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_8
cpu/event=0xCD,umask=0x01,ldlat=0x8,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_8/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.126 MB perf.data (~5522 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_16
cpu/event=0xCD,umask=0x01,ldlat=0x10,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_16/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.090 MB perf.data (~3911 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_32
cpu/event=0xCD,umask=0x01,ldlat=0x20,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_32/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.056 MB perf.data (~2429 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_64
cpu/event=0xCD,umask=0x01,ldlat=0x40,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_64/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.012 MB perf.data (~516 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_128
cpu/event=0xCD,umask=0x01,ldlat=0x80,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_128/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.014 MB perf.data (~604 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_256
cpu/event=0xCD,umask=0x01,ldlat=0x100,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_256/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.004 MB perf.data (~172 samples) ]
MEM_TRANS_RETIRED.LOAD_LATENCY_GT_512
cpu/event=0xCD,umask=0x01,ldlat=0x200,name=MEM_TRANS_RETIRED_LOAD_LATENCY_GT_512/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.003 MB perf.data (~129 samples) ]
MEM_UOPS_RETIRED.STLB_MISS_LOADS
cpu/event=0xD0,umask=0x11,name=MEM_UOPS_RETIRED_STLB_MISS_LOADS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.006 MB perf.data (~261 samples) ]
MEM_UOPS_RETIRED.STLB_MISS_STORES
cpu/event=0xD0,umask=0x12,name=MEM_UOPS_RETIRED_STLB_MISS_STORES/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.016 MB perf.data (~694 samples) ]
MEM_UOPS_RETIRED.LOCK_LOADS
cpu/event=0xD0,umask=0x21,name=MEM_UOPS_RETIRED_LOCK_LOADS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.036 MB perf.data (~1554 samples) ]
MEM_UOPS_RETIRED.SPLIT_LOADS
cpu/event=0xD0,umask=0x41,name=MEM_UOPS_RETIRED_SPLIT_LOADS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.003 MB perf.data (~121 samples) ]
MEM_UOPS_RETIRED.SPLIT_STORES
cpu/event=0xD0,umask=0x42,name=MEM_UOPS_RETIRED_SPLIT_STORES/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.039 MB perf.data (~1707 samples) ]
MEM_UOPS_RETIRED.ALL_LOADS
cpu/event=0xD0,umask=0x81,name=MEM_UOPS_RETIRED_ALL_LOADS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.179 MB perf.data (~7839 samples) ]
MEM_UOPS_RETIRED.ALL_STORES
cpu/event=0xD0,umask=0x82,name=MEM_UOPS_RETIRED_ALL_STORES/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.164 MB perf.data (~7144 samples) ]
MEM_LOAD_UOPS_RETIRED.L1_HIT
cpu/event=0xD1,umask=0x01,name=MEM_LOAD_UOPS_RETIRED_L1_HIT/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.179 MB perf.data (~7826 samples) ]
MEM_LOAD_UOPS_RETIRED.L2_HIT
cpu/event=0xD1,umask=0x02,name=MEM_LOAD_UOPS_RETIRED_L2_HIT/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.084 MB perf.data (~3689 samples) ]
MEM_LOAD_UOPS_RETIRED.L3_HIT
cpu/event=0xD1,umask=0x04,name=MEM_LOAD_UOPS_RETIRED_L3_HIT/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.041 MB perf.data (~1779 samples) ]
MEM_LOAD_UOPS_RETIRED.L1_MISS
cpu/event=0xD1,umask=0x08,name=MEM_LOAD_UOPS_RETIRED_L1_MISS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.088 MB perf.data (~3827 samples) ]
MEM_LOAD_UOPS_RETIRED.L2_MISS
cpu/event=0xD1,umask=0x10,name=MEM_LOAD_UOPS_RETIRED_L2_MISS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.056 MB perf.data (~2439 samples) ]
MEM_LOAD_UOPS_RETIRED.L3_MISS
cpu/event=0xD1,umask=0x20,name=MEM_LOAD_UOPS_RETIRED_L3_MISS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.028 MB perf.data (~1229 samples) ]
MEM_LOAD_UOPS_RETIRED.HIT_LFB
cpu/event=0xD1,umask=0x40,name=MEM_LOAD_UOPS_RETIRED_HIT_LFB/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.055 MB perf.data (~2402 samples) ]
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
cpu/event=0xD2,umask=0x01,name=MEM_LOAD_UOPS_L3_HIT_RETIRED_XSNP_MISS/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~107 samples) ]
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
cpu/event=0xD2,umask=0x02,name=MEM_LOAD_UOPS_L3_HIT_RETIRED_XSNP_HIT/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.003 MB perf.data (~119 samples) ]
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
cpu/event=0xD2,umask=0x04,name=MEM_LOAD_UOPS_L3_HIT_RETIRED_XSNP_HITM/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~107 samples) ]
MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
cpu/event=0xD2,umask=0x08,name=MEM_LOAD_UOPS_L3_HIT_RETIRED_XSNP_NONE/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.038 MB perf.data (~1649 samples) ]
MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM
cpu/event=0xD3,umask=0x01,name=MEM_LOAD_UOPS_L3_MISS_RETIRED_LOCAL_DRAM/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.028 MB perf.data (~1204 samples) ]
BR_MISP_RETIRED.NEAR_TAKEN
cpu/event=0xC5,umask=0x20,name=BR_MISP_RETIRED_NEAR_TAKEN/pp
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.132 MB perf.data (~5777 samples) ]

-- 
ak@linux.intel.com -- Speaking for myself only

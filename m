Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3A1QQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:16:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1QQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:16:17 -0500
Date: Mon, 28 Jan 2013 17:16:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/12] perf, x86: Basic Haswell PMU support v2
Message-ID: <20130128161616.GS30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-3-git-send-email-andi@firstfloor.org> <CABPqkBTwqYOiKDreq394Nq=ds8b0qg2igTdBoJ8JpB0Dd2RbRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTwqYOiKDreq394Nq=ds8b0qg2igTdBoJ8JpB0Dd2RbRg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static struct event_constraint intel_hsw_event_constraints[] =
> > +{
> > +       FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> > +       FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> > +       FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
> > +       INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
> 
> You're covering the entire event here, so comment should be: L1D_PEND_MISS.*

Ok.

> 
> > +       INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
> > +       INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
> > +       EVENT_CONSTRAINT_END
> 
> You are missing constraint on the following public events:
> - CYCLE_ACTIVITY (0xa3)

AFAIK that's not a PEBS event.

> 
> > +};
> > +
> >  static u64 intel_pmu_event_map(int hw_event)
> >  {
> >         return intel_perfmon_event_map[hw_event];
> > @@ -2107,6 +2118,24 @@ __init int intel_pmu_init(void)
> >                 break;
> >
> >
> > +       case 60: /* Haswell Client */
> > +       case 70:
> > +       case 71:
> > +               memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
> > +                      sizeof(hw_cache_event_ids));
> > +
> > +               intel_pmu_lbr_init_nhm();
> > +
> I suspect this one should be intel_pmu_lbr_init_snb(), otherwise
> you inherit the broken filter workarounds.

Good point.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

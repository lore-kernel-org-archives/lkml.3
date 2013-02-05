Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3BETJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:09:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35064 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3BETJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:09:05 -0500
Date: Tue, 5 Feb 2013 20:09:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting
Message-ID: <20130205190902.GV30577@one.firstfloor.org>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org> <1360028954-16946-5-git-send-email-andi@firstfloor.org> <CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:15:26PM +0100, Stephane Eranian wrote:
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -2228,5 +2228,11 @@ __init int intel_pmu_init(void)
> >                 }
> >         }
> >
> > +       /* Support full width counters using alternative MSR range */
> > +       if (x86_pmu.intel_cap.fw_write) {
> > +               x86_pmu.max_period = x86_pmu.cntval_mask;
> 
> Something is not clear to me: What happens to the fixed counters with
> full writes? Were they already full-width? The SDM does not explain what
> happens to them with this extension. Could you clarify?

I tested and they always support the full reported width.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

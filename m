Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JCR6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:58:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39324 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3JCR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:58:17 -0400
Date: Thu, 3 Oct 2013 10:57:57 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9][v5] powerpc/perf: Export Power8 generic events in
 sysfs
Message-ID: <20131003175757.GA21561@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <20131003040431.GB17237@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003040431.GB17237@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100317-9332-0000-0000-000001A38424
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Tue, Oct 01, 2013 at 05:15:03PM -0700, Sukadev Bhattiprolu wrote:
| > Export generic perf events for Power8 in sysfs.
| > 
| > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
| > ---
| >  arch/powerpc/perf/power8-pmu.c |   23 +++++++++++++++++++++++
| >  1 file changed, 23 insertions(+)
| > 
| > diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
| > index 976c203..b991b2e 100644
| > --- a/arch/powerpc/perf/power8-pmu.c
| > +++ b/arch/powerpc/perf/power8-pmu.c
| > @@ -510,6 +510,28 @@ static void power8_disable_pmc(unsigned int pmc, unsigned long mmcr[])
| >  		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SHIFT(pmc + 1));
| >  }
| >  
| > +GENERIC_EVENT_ATTR(cpu-cyles,			PM_CYC);
| > +GENERIC_EVENT_ATTR(stalled-cycles-frontend,	PM_GCT_NOSLOT_CYC);
| > +GENERIC_EVENT_ATTR(stalled-cycles-backend,	PM_CMPLU_STALL);
| > +GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
| > +GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
| > +GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
| 
| And here you use PM_ not PME_ - I'm confused.

It is a bit confusing. The GENERIC_EVENT_ATTR() adds the PME_ prefix. I
kept this change minimal for now, since we will have to revisit this once
the Power8 events are finalized.

Sukadev


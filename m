Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3JQJH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:07:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3JQJH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:07:57 -0400
Date: Thu, 17 Oct 2013 11:07:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Message-ID: <20131017090730.GK2675@laptop.programming.kicks-ass.net>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
 <20131010180049.GD9929@pd.tnic>
 <20131016124627.GA2611@gmail.com>
 <CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
 <20131016175302.GB4100@infradead.org>
 <CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
 <20131017081420.GB22705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017081420.GB22705@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:14:20AM +0200, Ingo Molnar wrote:
> > > I.e. you would be encoding the counter unit as the suffix, might as well
> > > call it "power/cores.joules" and use the dot as the separator for the
> > > unit, but would be just a compact form to encode the counter->unit
> > > table.
> >
> > May be easier to add a sysfs entry with the unit to display.
> 
> Yes - with no entry meaning a raw 'count' or such.

The downside to such a sysfs entry will be the scope. It would either be
pmu wide (unwieldy for many PMUs) or be only per listed event; and we
really don't want exhaustive event lists in the kernel.


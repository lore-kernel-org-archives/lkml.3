Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3GPOfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:35:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3GPOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:35:36 -0400
Date: Tue, 16 Jul 2013 16:34:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf: add two new features
Message-ID: <20130716143429.GK23818@dyad.programming.kicks-ass.net>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
 <20130628152745.GH6626@twins.programming.kicks-ass.net>
 <51CDE273.9080209@intel.com>
 <51E4E688.10405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E4E688.10405@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:22:00AM +0300, Adrian Hunter wrote:
> On 28/06/13 22:22, Adrian Hunter wrote:
> > On 28/06/2013 6:27 p.m., Peter Zijlstra wrote:
> >> On Fri, Jun 28, 2013 at 04:22:16PM +0300, Adrian Hunter wrote:
> >>> Hi
> >>>
> >>> Please consider these two new perf features:
> >>>        x86: add ability to calculate TSC from perf sample timestamps
> >>>        perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
> >>
> >> Please explain to us why you'd like to do this..
> > 
> > I will see what information I can dig up.  The short answer is that I need
> > to disable and re-enable a perf event but still be able to map IPs to their
> > DSOs and symbols - which means not losing mmap events.
> 
> Any other comments?

Ah, thanks for the reminder.. well, I've applied patches 1-3 as those seem
useful on their own. I'm not entirely convinced about the 'keep tracking' thing
though.

It seems to me you could get the same by opening a second event into the same
buffer and keeping that enabled.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3AQK2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:28:11 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52944 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759493Ab3AQK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:28:05 -0500
Date: Thu, 17 Jan 2013 10:23:26 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zij@mx0.arm.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130117102325.GA3699@mudshark.cambridge.arm.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <20130116131318.GF16543@mudshark.cambridge.arm.com>
 <20130116133033.GC1042@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116133033.GC1042@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 01:30:33PM +0000, Jiri Olsa wrote:
> On Wed, Jan 16, 2013 at 01:13:18PM +0000, Will Deacon wrote:
> > On Tue, Jan 15, 2013 at 01:39:50PM +0000, Jiri Olsa wrote:
> > > The formula can currently contain any event from the set::events
> > > plus any number (int). There'll be support in future for outside
> > > values runtime and other if needed.
> > 
> > Just to say that I *really* like this idea! If we extended it to include
> > other operators then it would help us on ARM, where we often have events
> > like 'cache accesses' and 'cache misses' but not 'cache hits'.
> 
> great, thanks for sharing this
> 
> The current operators set is just basic one to show the idea,
> it can/will be expanded.

Makes sense.

> > > My current thinking is to have generic formulas file(s) for architectural
> > > events and add arch-specific ones once when we have the support for
> > > non-architectural events (already sent RFC, v2 is on its way..).
> > 
> > Would the architectural formula files also be in userspace, or is there any
> > merit to including useful PMU-specific formulae in sysfs, along with the
> > other PMU files?
> 
> hum, isn't this too specific for sysfs files?
> 
> I think that's going to be the perf tool specific info.. so it's going
> to be placed in its configuration files.

Understood. It would just be nice if the ARM perf backend could implement
more of the generic events, which would be possible if the kernel could
expose these formulae for those. Plumbing that together probably still
requires userspace changes though, in which case it's not worth it.

Will

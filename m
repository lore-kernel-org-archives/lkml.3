Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaJXND0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:03:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:60880 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576AbaJXNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:03:24 -0400
Date: Fri, 24 Oct 2014 10:03:20 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/16] perf pmu: Let pmu's with no events show up on perf
 list
Message-ID: <20141024130320.GA14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
 <87y4s6cak7.fsf@sejong.aot.lge.com>
 <20141024125702.GZ14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024125702.GZ14687@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 09:57:02AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Oct 24, 2014 at 02:15:52PM +0900, Namhyung Kim escreveu:
> > On Thu, 23 Oct 2014 13:45:10 +0300, Adrian Hunter wrote:
> > > +		if (pmu->selectable) {
> > > +			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
> > > +			aliases[j] = strdup(buf);
> > 
> > You need to check the return value here (and above too).
> 
> Well spotted, fixing this up.

Oh well, this print_pmu_events() function needs some care, it starts by
trying to alloc the array, if it fails, it silently returns, does that
mean that there are no pmu events? Or that memory allocation failed?

Ok, will do the fixes in a separate patch...

- Arnaldo

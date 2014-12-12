Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbaLLSxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:53:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:47452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbaLLSx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:53:29 -0500
Date: Fri, 12 Dec 2014 15:53:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 00/22] perf tools: Introduce an abstraction for
 Instruction Tracing
Message-ID: <20141212185324.GF9845@kernel.org>
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
 <548B1425.7090500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548B1425.7090500@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 12, 2014 at 09:13:25AM -0700, David Ahern escreveu:
> On 12/12/14 6:47 AM, Adrian Hunter wrote:
> >Here is V3 of some more preparatory patches for Intel PT
> >that introduce an abstraction for Instruction tracing.

> This is an x86-Intel only feature correct? If that is the case then the code
> should be not compiled for other architectures.


My view so far is that what has been pushed for inclusion facilitates
supporting an event stream that is so huge that needs to be mapped
directly from hardware to tools, that would receive it in a special
area obtained from perf_mmap(). What comes in those events? In this
case, this Intel PT stuff, but noving (should) prevent it from being
used for similar situations for other architectures.

I wonder if we could somehow rename this from 'itrace' to some other
more meaningful name given the above understanding of this being just
a way to directly funnel events from hardware to userspace together with
perf metadata (PERF_RECORD_FORK, PERF_RECORD_MMAP, etc) + other events.

In the kernel this was called a "AUX" thing, which I also think is
vague...

- Arnaldo

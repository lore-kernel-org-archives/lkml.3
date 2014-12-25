Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaLYWJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:09:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaLYWJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:09:13 -0500
Date: Thu, 25 Dec 2014 23:08:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy
 tracking event
Message-ID: <20141225220850.GB8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419405333-27952-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:01PM +0900, Namhyung Kim wrote:
> When multi file support is enabled, a dummy tracking event will be
> used to track metadata (like task, comm and mmap events) for a session
> and actual samples will be recorded in separate files.
> 
> Provide separate mmap to the dummy tracking event.  The size is fixed
> to 128KiB (+ 1 page) as the event rate will be lower than samples.  I
> originally wanted to use a single mmap for this but cross-cpu sharing
> is prohibited so it's per-cpu (or per-task) like normal mmaps.

maybe this needs to be applied after next patch?
  perf tools: Introduce perf_evlist__mmap_multi

I'm getting compile error:

[jolsa@krava perf]$ make JOBS=1
  BUILD:   Doing 'make -j1' parallel build
  CC       util/evlist.o
util/evlist.c: In function ‘perf_evlist__mmap_per_evsel’:
util/evlist.c:937:9: error: ‘struct mmap_params’ has no member named ‘track’
   if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
         ^
util/evlist.c: In function ‘perf_evlist__mmap’:
util/evlist.c:1092:62: error: ‘use_track_mmap’ undeclared (first use in this function)
  if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, use_track_mmap) < 0)
                                                              ^
util/evlist.c:1092:62: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [util/evlist.o] Error 1
make: *** [all] Error 2

jirka

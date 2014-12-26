Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLZBpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:45:49 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:48291 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLZBps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:45:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141225220850.GB8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org> <20141225220850.GB8719@krava>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 26 Dec 2014 10:45:27 +0900
X-Google-Sender-Auth: D-_r2N7dVDjMgx7iYcoUkF1ZtBo
Message-ID: <CAM9d7cjOkCXAMa-2bWmtZmMinuC3_N4DtN9LO6Nx+poggggaZw@mail.gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy tracking event
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 7:08 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:01PM +0900, Namhyung Kim wrote:
>> When multi file support is enabled, a dummy tracking event will be
>> used to track metadata (like task, comm and mmap events) for a session
>> and actual samples will be recorded in separate files.
>>
>> Provide separate mmap to the dummy tracking event.  The size is fixed
>> to 128KiB (+ 1 page) as the event rate will be lower than samples.  I
>> originally wanted to use a single mmap for this but cross-cpu sharing
>> is prohibited so it's per-cpu (or per-task) like normal mmaps.
>
> maybe this needs to be applied after next patch?
>   perf tools: Introduce perf_evlist__mmap_multi

Oops, sorry.  it seems the code was mixed after huge number of
rebase..  The commit order is right but it just has a wrong hunk.


>
> I'm getting compile error:
>
> [jolsa@krava perf]$ make JOBS=1
>   BUILD:   Doing 'make -j1' parallel build
>   CC       util/evlist.o
> util/evlist.c: In function ‘perf_evlist__mmap_per_evsel’:
> util/evlist.c:937:9: error: ‘struct mmap_params’ has no member named ‘track’
>    if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
>          ^
> util/evlist.c: In function ‘perf_evlist__mmap’:
> util/evlist.c:1092:62: error: ‘use_track_mmap’ undeclared (first use in this function)
>   if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, use_track_mmap) < 0)
>                                                               ^
> util/evlist.c:1092:62: note: each undeclared identifier is reported only once for each function it appears in
> make[1]: *** [util/evlist.o] Error 1
> make: *** [all] Error 2

Will fix, thanks
Namhyung

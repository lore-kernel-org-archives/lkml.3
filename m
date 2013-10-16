Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3JPGPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:15:08 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42551 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3JPGPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:15:06 -0400
Date: Wed, 16 Oct 2013 08:15:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        dsahern@gmail.com, acme@redhat.com, ak@linux.intel.com,
        jolsa@redhat.com, hughd@google.com
Subject: Re: [PATCH] perf: revert PERF_RECORD_MMAP2 support
Message-ID: <20131016061502.GB21109@gmail.com>
References: <20131015161843.GA17653@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015161843.GA17653@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> 
> This unified patch removes the following commits
> for both kernel and perf tool:
> 
> 6adb0b0 perf tools: Add default handler for mmap2 events
> 384c671 perf trace: Add mmap2 handler
> 5c5e854 perf tools: Add attr->mmap2 support
> d008d52 perf: Fix up MMAP2 buffer space reservation
> 13d7a24 perf: Add attr->mmap2 attribute to an event
> 
> The MMAP2 record extension is not quite ready for prime time.
> We have identified address space cases where mappings would
> not be reported properly when apps fiddled directly with clone()
> and VM_CLONE. We will revisit the patch series soon.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/uapi/linux/perf_event.h |   24 +----------------
>  kernel/events/core.c            |   47 +++-----------------------------
>  tools/perf/builtin-annotate.c   |    1 -
>  tools/perf/builtin-inject.c     |   15 -----------
>  tools/perf/builtin-mem.c        |    1 -
>  tools/perf/builtin-report.c     |    1 -
>  tools/perf/builtin-script.c     |    1 -
>  tools/perf/builtin-trace.c      |    1 -
>  tools/perf/tests/perf-record.c  |   15 +++--------
>  tools/perf/util/build-id.c      |    1 -
>  tools/perf/util/event.c         |   56 +++++++++------------------------------
>  tools/perf/util/event.h         |   19 -------------
>  tools/perf/util/evsel.c         |   16 +++--------
>  tools/perf/util/header.c        |    3 ---
>  tools/perf/util/machine.c       |   53 +-----------------------------------
>  tools/perf/util/machine.h       |    1 -
>  tools/perf/util/map.c           |    8 +-----
>  tools/perf/util/map.h           |    8 ++----
>  tools/perf/util/session.c       |   27 +------------------
>  tools/perf/util/tool.h          |    1 -
>  20 files changed, 30 insertions(+), 269 deletions(-)

Ugh, that's way too large.

I thought the plan was to do a minimal revert. Is there really no way to 
do this in a (much) shorter fashion?

For example by a simple patch that returns -EINVAL (or -ENOSYS) if the new 
flag is used - i.e. behaves like the old kernel in that regard - but 
leaves the rest in place. (the 'rest' will hopefully be fixed for v3.13)

Tooling will then fall back as if it was an old kernel - i.e. no changes 
needed there at all. Right?

Hm?

	Ingo

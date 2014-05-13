Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaEMQxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaEMQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:53:05 -0400
Date: Tue, 13 May 2014 12:52:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/6 V2] perf: Enable mmap2 and add dcacheline sorting
Message-ID: <20140513165225.GP39568@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:48:11PM -0400, Don Zickus wrote:
> These patches enable mmap2 support in the kernel and perf to
> allow support for data cacheline sorting.
> 
> V2: change cacheline to dcacheline (Namhyung Kim)
>     change dcacheline alogorithm a bit
>     re-order mmap2 patches (Namhyung Kim)
>     provide documentation (Andi Kleen)

One other thing, this is based off of Jiri's perf/core branch
13ce34df11833482cd698331fdbb3f8ced06340d.  I think that is the new/temp
perf tip for now.

Cheers,
Don

>  
> Don Zickus (6):
>   events, perf: Pass protection and flags bits through mmap2 interface
>   Revert "perf: Disable PERF_RECORD_MMAP2 support"
>   perf: Update mmap2 interface with protection and flag bits
>   perf report: Add mem-mode documentation to report command
>   perf: Add cpumode to struct hist_entry
>   perf: Add dcacheline sort
> 
>  include/uapi/linux/perf_event.h          |   1 +
>  kernel/events/core.c                     |  37 +++++++++--
>  tools/perf/Documentation/perf-report.txt |  23 +++++++
>  tools/perf/builtin-report.c              |   2 +-
>  tools/perf/util/event.c                  |  59 +++++++++++------
>  tools/perf/util/event.h                  |   2 +
>  tools/perf/util/evsel.c                  |   1 +
>  tools/perf/util/hist.c                   |   7 ++-
>  tools/perf/util/hist.h                   |   1 +
>  tools/perf/util/machine.c                |   4 +-
>  tools/perf/util/map.c                    |   4 +-
>  tools/perf/util/map.h                    |   4 +-
>  tools/perf/util/sort.c                   | 105 +++++++++++++++++++++++++++++++
>  tools/perf/util/sort.h                   |   2 +
>  14 files changed, 222 insertions(+), 30 deletions(-)
> 
> -- 
> 1.7.11.7
> 

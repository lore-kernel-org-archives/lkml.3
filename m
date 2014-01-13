Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaAMQy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:54:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbaAMQyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:54:55 -0500
Date: Mon, 13 Jan 2014 11:54:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: Gaurav Jain <gjain@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Message-ID: <20140113165441.GB25953@redhat.com>
References: <1389501134-13116-1-git-send-email-gjain@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389501134-13116-1-git-send-email-gjain@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 08:32:14PM -0800, Gaurav Jain wrote:
> Anon records usually do not have the 'execname' entry. However if they are on
> the heap, the execname shows up as '[heap]'. The fix considers any executable
> entries in the map that do not have a name or are on the heap as anon records
> and sets the name to '//anon'.
> 
> This fixes JIT profiling for records on the heap.

I guess I don't understand the need for this fix.  It seems breaking out
//anon vs. [heap] would be useful.  Your patch is saying otherwise.  Can
give a description of the problem you are trying to solve?

Also style issue below..

> 
> Signed-off-by: Gaurav Jain <gjain@fb.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Arun Sharma <asharma@fb.com>
> ---
>  tools/perf/util/event.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index bb788c1..ae9c55b 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -224,10 +224,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  				continue;
>  
>  			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
> -		}
> -
> -		if (!strcmp(execname, ""))
> +		} if (!strcmp(execname, "") || !strcmp(execname, "[heap]")) {

The '} if' part should seperate the 'if' on to its own line (unless you
meant an 'else' in there).

Cheers,
Don

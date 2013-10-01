Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3JAItG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:49:06 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57924 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3JAIs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:48:57 -0400
Date: Tue, 1 Oct 2013 10:48:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf tool: don't print bogus data on -e cycles
Message-ID: <20131001084853.GH21793@gmail.com>
References: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
 <1380539585-23859-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380539585-23859-3-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> When only the cycles event is requested:
> 
> $ perf stat -e cycles dd if=/dev/zero of=/dev/null count=1000000
> 1000000+0 records in
> 1000000+0 records out
> 512000000 bytes (512 MB) copied, 0.26123 s, 2.0 GB/s
> 
>  Performance counter stats for 'dd if=/dev/zero of=/dev/null count=1000000':
> 
>        911,626,453 cycles                    #    0.000 GHz
> 
>        0.262113350 seconds time elapsed
> 
> The 0.000 GHz comment in the output is totally bogus and misleading. It
> happens because update_shadow_stats() doesn't touch runtime_nsecs_stats;
> it is only written when a requested counter matches a SW_TASK_CLOCK. In
> our case, since we have only requested HW_CPU_CYCLES,
> runtime_nsecs_stats is unavailable. So, omit printing the comment
> altogether.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-stat.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

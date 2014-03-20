Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaCTKmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:42:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaCTKmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:42:17 -0400
Date: Thu, 20 Mar 2014 09:33:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/6] perf tools: Share map groups within process
Message-ID: <20140320083333.GA3762@krava.redhat.com>
References: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 03:46:50PM +0100, Jiri Olsa wrote:
> hi,
> this patchset moves thread's map_groups to be dynamically
> allocated and shared within process threads.
> 
> The main benefit would be to be able to look up memory
> map from any thread that belongs to the process.
> 
> This implements one of the solution ideas for issue
> described by Don in following thread:
> http://marc.info/?l=linux-kernel&m=139403876017159&w=2
> 
> RFC changes:
>   - added automated test for thread map groups get/put methods
>   - fix reference count for case described by Namhyung
>   - rename the mmap-events.c test to mmap-thread-lookup.c
>   - added PROT_EXEC to mmap call in tests/mmap-thread-lookup.c
>     as it's not implied by default on all archs (Namhyung)
>   - lazy mg allocation in thread__find_addr_map (Namhyung)
>   - fix compilation failures (Arnaldo)
> 
> also available in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_mmaps

Arnaldo,
I rebased this to your latest perf/core

thanks,
jirka

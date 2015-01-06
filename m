Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbbAFPNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:13:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbbAFPNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:13:34 -0500
Date: Tue, 6 Jan 2015 13:13:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: peterz@infradead.org, jolsa@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        bp@suse.de, linux-arch@vger.kernel.org, Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH 0/5] Perf fixes for ARC + uClibc
Message-ID: <20150106151329.GD2517@redhat.com>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 06, 2015 at 07:22:10PM +0530, Vineet Gupta escreveu:
> Hi,
> 
> This series based off linux-next of 20150105 allows us to build/use perf
> for ARC with uClibc based userland.

Do you have some ready made ARC VM image with devel tools I could use with qemu?

- Arnaldo
 
> * 1/5 is really a resend of old patch posted by Alexey a while back
> * 2/5 is uClibc build spew seen on ARM as well
> * 3/5 likewise
> * 4/5 is uClibc config specific
> * 5/5 is uClibc pthread library flavour specific
>   It adds a stub for pthread_attr_setaffinity_np
>   I can rework it to disable the futex tests altogether if people think that is
>   cleaner
> 
> Please review and consider applying.
> W/o these perf doesn't build and/or work for ARC.
> 
> Thx,
> -Vineet
> 
> Alexey Brodkin (1):
>   perf tools: [uclibc] fix statfs.f_type data type mismatch build error
> 
> Vineet Gupta (4):
>   perf tools: [uclibc] Elide strlcpy warning
>   perf tools: [uclibc] Avoid build splat for syscall numbers
>   perf tools: [uclibc] don't rely on glibc malloc working for sz 0
>   perf tools: [uclibc] provide stub for pthread_attr_setaffinity_np
> 
>  tools/lib/api/fs/debugfs.c                  |  2 +-
>  tools/lib/api/fs/fs.c                       |  2 +-
>  tools/perf/bench/futex.h                    | 13 +++++++++++++
>  tools/perf/bench/sched-pipe.c               |  1 -
>  tools/perf/builtin-top.c                    |  1 -
>  tools/perf/config/Makefile                  |  6 ++++++
>  tools/perf/config/feature-checks/Makefile   |  4 ++++
>  tools/perf/config/feature-checks/test-all.c |  5 +++++
>  tools/perf/perf-sys.h                       |  1 -
>  tools/perf/util/cache.h                     |  2 ++
>  tools/perf/util/header.c                    |  2 +-
>  11 files changed, 33 insertions(+), 6 deletions(-)
> 
> -- 
> 1.9.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3LIK13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab3LIK11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:27:27 -0500
Date: Mon, 9 Dec 2013 11:26:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 2/2] tools/: Move fs.* to lib/api/fs/
Message-ID: <20131209102650.GD1242@krava.brq.redhat.com>
References: <1386260752-16436-1-git-send-email-bp@alien8.de>
 <1386260752-16436-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386260752-16436-3-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:25:52PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Move to generic library and kill magic.h as it is needed only in fs.h.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  tools/lib/api/Makefile                                     |  2 ++
>  tools/{perf/util => lib/api/fs}/fs.c                       | 11 ++++++++---
>  tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} | 12 +++++-------
>  tools/perf/Makefile.perf                                   |  3 ---
>  tools/perf/tests/parse-events.c                            |  2 +-
>  tools/perf/util/cpumap.c                                   |  2 +-
>  tools/perf/util/fs.h                                       |  7 -------
>  tools/perf/util/pmu.c                                      |  2 +-
>  tools/perf/util/python-ext-sources                         |  2 +-
>  tools/perf/util/record.c                                   |  2 +-
>  10 files changed, 20 insertions(+), 25 deletions(-)
>  rename tools/{perf/util => lib/api/fs}/fs.c (91%)
>  rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
>  delete mode 100644 tools/perf/util/fs.h
> 
> diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
> index d749cdc8e1d4..2a354292d781 100644
> --- a/tools/lib/api/Makefile
> +++ b/tools/lib/api/Makefile
> @@ -8,8 +8,10 @@ LIB_H=
>  LIB_OBJS=
>  
>  LIB_H += fs/debugfs.h
> +LIB_H += fs/fs.h
>  
>  LIB_OBJS += $(OUTPUT)fs/debugfs.o
> +LIB_OBJS += $(OUTPUT)fs/fs.o
>  
>  LIBFILE = libapikfs.a
>  
> diff --git a/tools/perf/util/fs.c b/tools/lib/api/fs/fs.c
> similarity index 91%
> rename from tools/perf/util/fs.c
> rename to tools/lib/api/fs/fs.c
> index f5be1f26e724..ff8907275cfb 100644
> --- a/tools/perf/util/fs.c
> +++ b/tools/lib/api/fs/fs.c
> @@ -1,8 +1,13 @@
> +/* TODO merge/factor into debugfs.c */

I guess now above one should be:

 TODO merge/factor debugfs object in here

;-)

jirka

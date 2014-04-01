Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaDACmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaDACmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:42:53 -0400
Date: Mon, 31 Mar 2014 22:42:30 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/4] perf, kmem: Utilize the new generic cpunode_map
Message-ID: <20140401024230.GR25953@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-3-git-send-email-dzickus@redhat.com>
 <20140329171047.GC2022@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329171047.GC2022@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 06:10:47PM +0100, Jiri Olsa wrote:
> On Mon, Mar 24, 2014 at 03:32:55PM -0400, Don Zickus wrote:
> > Use the previous patch implementation of cpunode_map for builtin-kmem.c
> > Should not be any functional difference.
> > 
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  tools/perf/builtin-kmem.c | 78 ++---------------------------------------------
> >  1 file changed, 3 insertions(+), 75 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> > index 929462a..a61783a 100644
> > --- a/tools/perf/builtin-kmem.c
> > +++ b/tools/perf/builtin-kmem.c
> > @@ -14,6 +14,7 @@
> >  #include "util/parse-options.h"
> >  #include "util/trace-event.h"
> >  #include "util/data.h"
> > +#include "util/cpumap.h"
> >  
> >  #include "util/debug.h"
> >  
> > @@ -31,9 +32,6 @@ static int			caller_lines = -1;
> >  
> >  static bool			raw_ip;
> >  
> > -static int			*cpunode_map;
> > -static int			max_cpu_num;
> > -
> >  struct alloc_stat {
> >  	u64	call_site;
> >  	u64	ptr;
> > @@ -55,76 +53,6 @@ static struct rb_root root_caller_sorted;
> >  static unsigned long total_requested, total_allocated;
> >  static unsigned long nr_allocs, nr_cross_allocs;
> >  
> > -#define PATH_SYS_NODE	"/sys/devices/system/node"
> > -
> > -static int init_cpunode_map(void)
> > -{
> > -	FILE *fp;
> > -	int i, err = -1;
> > -
> > -	fp = fopen("/sys/devices/system/cpu/kernel_max", "r");
> 
> so the factored code from previous patches now reads
> the max_cpu_num value from:
>   /sys/devices/system/cpu/possible
> 
> is this intentional?

Yeah, I was trying to save bits.  No need to allocate for 5100 cpus when
only 128 are used.

> 
> I think we want to have separate patches for code changes
> and for changing the file with some comment.

So you want me to split the previous patch into two.  One for code
movement, the other for the path change?

Cheers,
Don

> 
> jirka

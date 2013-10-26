Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3JZSxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 14:53:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3JZSxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:53:48 -0400
Date: Sat, 26 Oct 2013 20:53:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] perf tools: Add missing data.h into LIB_H headers
Message-ID: <20131026185314.GA14973@krava.brq.redhat.com>
References: <1381847254-28809-1-git-send-email-jolsa@redhat.com>
 <1381847254-28809-3-git-send-email-jolsa@redhat.com>
 <52676DFC.9030402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52676DFC.9030402@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:34:36AM +0300, Adrian Hunter wrote:
> On 15/10/13 17:27, Jiri Olsa wrote:
> > Adding perf_data_file__open interface to data object
> > to open the perf.data file for both read and write.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > ---
> >  tools/perf/Makefile.perf    |   1 +
> >  tools/perf/builtin-record.c |  34 +------------
> >  tools/perf/builtin-top.c    |   9 +---
> >  tools/perf/util/data.c      | 120 ++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/data.h      |   4 ++
> >  tools/perf/util/session.c   |  95 +++++++++++------------------------
> >  tools/perf/util/session.h   |   2 +-
> >  7 files changed, 158 insertions(+), 107 deletions(-)
> >  create mode 100644 tools/perf/util/data.c
> > 
> > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > index c873e03..326a26e 100644
> > --- a/tools/perf/Makefile.perf
> > +++ b/tools/perf/Makefile.perf
> > @@ -365,6 +365,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
> >  LIB_OBJS += $(OUTPUT)util/stat.o
> >  LIB_OBJS += $(OUTPUT)util/record.o
> >  LIB_OBJS += $(OUTPUT)util/srcline.o
> > +LIB_OBJS += $(OUTPUT)util/data.o
> 
> Also needs:
> 
> 	LIB_H += util/data.h
> 

oops, I knew I forgot something.. patch is attached

thanks,
jirka


---
Adding missing data.h into LIB_H headers so the build
could keep up with its changes.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8a9ca38..bc7cfa1 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -295,6 +295,7 @@ LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
 LIB_H += ui/ui.h
+LIB_H += util/data.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
-- 
1.7.11.7


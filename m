Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3KZMys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab3KZMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:54:46 -0500
Date: Tue, 26 Nov 2013 13:54:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCHv2] perf tools: Fix tags/TAGS targets rebuilding
Message-ID: <20131126125412.GJ1267@krava.brq.redhat.com>
References: <1385464890-19876-1-git-send-email-jolsa@redhat.com>
 <20131126113108.GE2410@gmail.com>
 <20131126115043.GG1267@krava.brq.redhat.com>
 <20131126120055.GA6103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126120055.GA6103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 01:00:55PM +0100, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Tue, Nov 26, 2013 at 12:31:08PM +0100, Ingo Molnar wrote:

SNIP

> > > 
> > > Also note that we have duplicate code for this in Makefile.perf 
> > > already. Would it be possible to pass through this there and keep the 
> > > main Makefile is just a thin, minimal wrapper that adds default 
> > > parallelism, etc?
> > 
> > well, thats what I actually tried to do.. pass the
> > processing to the Makefile.perf otherwise it stops
> > in Makefile
> > 
> > I guess you want some generic way of doing that
> 
> If it's just these two phony targets that need to be in the main 
> makefile then I guess your approach is the simplest one and we should 
> do it like that instead of complicating the interface. If it gets 
> messier in the future we can reconsider?
> 

sounds good, pelase check v2

thanks,
jirka


---
Once the tags/TAGS file is generated it's never rebuilt
until it's removed by hand.

The reason is that the Makefile does not treat tags/TAGS
as targets but as files and thus won't rebuilt them
once they are in place.

Adding PHONY tags/TAGS targets into Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4835618..eefb9fb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -60,8 +60,11 @@ endef
 
 #
 # Needed if no target specified:
+# (Except for tags and TAGS targets. The reason is that the
+# Makefile does not treat tags/TAGS as targets but as files
+# and thus won't rebuilt them once they are in place.)
 #
-all:
+all tags TAGS:
	$(print_msg)
	$(make)
 
@@ -77,3 +80,5 @@ clean:
 %:
	$(print_msg)
	$(make)
+
+.PHONY: tags TAGS
-- 
1.8.3.1


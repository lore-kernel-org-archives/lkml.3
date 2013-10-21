Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3JUOUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:20:30 -0400
Received: from mail-gg0-f172.google.com ([209.85.161.172]:53923 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3JUOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:43 -0400
Date: Mon, 21 Oct 2013 11:14:28 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/19] perf tools: Fix libunwind build and feature
 detection for 32-bit build
Message-ID: <20131021141428.GB2245@ghostprotocols.net>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-14-git-send-email-adrian.hunter@intel.com>
 <20131020204346.GD12044@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131020204346.GD12044@krava>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 20, 2013 at 10:43:46PM +0200, Jiri Olsa escreveu:
> On Fri, Oct 18, 2013 at 03:29:10PM +0300, Adrian Hunter wrote:
> > Use -lunwind-x86 instead of -lunwind-x86_64 for 32-bit build.

> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

> Acked-by: Jiri Olsa <jolsa@redhat.com>

Doesn't apply because it depends on a patch in this series that I made a
question about, the "CFLAGS=-g ... one, but then can we avoid touching
this feature_check_code line with feature specific stuff, i.e. can't we
just touch LDFLAGS or CFLAGS?

- Arnaldo

--- tools/perf/config/Makefile
+++ tools/perf/config/Makefile
@@ -94,7 +96,7 @@
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))

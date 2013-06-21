Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806Ab3FUMua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:50:30 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:65150 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3FUMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:50:29 -0400
Date: Fri, 21 Jun 2013 14:50:20 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130621124939.GB11635@rric.localhost>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
 <20130620134154.GC1083@krava.brq.redhat.com>
 <20130620152603.GC4767@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620152603.GC4767@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri and Arnaldo,

On 20.06.13 12:26:03, Arnaldo Carvalho de Melo wrote:
> Robert, so this one is with:
> 
> 	cd tools/perf
> 	make install-doc
> 
> I tested with:
> 
> 	make -C tools/perf O=/tmp/build/perf install-doc
> 
> and it works, so it is just the in tree build that fails.

The patch below fixes this. Thanks for reporting.

-Robert


>From 69714303856005a1dc84c0594a4c3ec1013f8a80 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@calxeda.com>
Date: Fri, 21 Jun 2013 14:26:44 +0200
Subject: [PATCH] perf tools: Fixing in-tree documentation build error

Fixing build error for:

 $ cd tools/perf
 $ make install-doc

The following patch changed handling of the OUTPUT variable:

 79e10cb perf tools: Fix output directory of Documentation/

Now, OUTPUT is unset if the build directory is the current working dir
which is the usual case for kbuild. The xmlto rule could not handle
this. This patch fixes this.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/Documentation/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 1368e88..5a37a7c 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -271,7 +271,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
-- 
1.7.7.6


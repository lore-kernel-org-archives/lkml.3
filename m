Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaFCDKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:10:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63139 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaFCDKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:10:40 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, jolsa@redhat.com, jean.pihet@linaro.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: Re: [PATCH] perf: fix 'make help' message error
Date: Tue,  3 Jun 2014 11:10:31 +0800
Message-Id: <1401765031-29555-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <87egz6emef.fsf@sejong.aot.lge.com>
References: <87egz6emef.fsf@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Namhyung,

On Tue, Jun 3, 2014 at 10:51 AM, Namhyung Kim <namhyung@gmail.com> wrote:
>
> s/condiered/considered/ ?
>
>

Oops, sorry for the typo.

>>> has an empty value, so "prefix" is honored. However, "prefix" is unconditionally
>>> assigned to $HOME, regardless of what it is set to from command line. So our
>>> "prefix" setting got no respect and the actual destination falls back to $HOME.
>>>
>>> This patch fixes this issue and corrects the help message.
>
> With that changed,
>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks. I renew the patch for maintainers to pick up.

-----8<-----
Subject: [PATCH] perf: fix 'make help' message error
Currently 'make help' message has such hint:

   use "make prefix=<path> <install target>" to install to a particular
       path like make prefix=/usr/local install install-doc

But this is misleading, when I specify "prefix=/usr/local", it has got no
respect at all.

This is because that, "DESTDIR" is considered first. In this case, "DESTDIR"
has an empty value, so "prefix" is honored. However, "prefix" is unconditionally
assigned to $HOME, regardless of what it is set to from command line. So our
"prefix" setting got no respect and the actual destination falls back to $HOME.

This patch fixes this issue and corrects the help message.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 tools/perf/Makefile.perf   | 4 ++--
 tools/perf/config/Makefile | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..5918063 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -784,8 +784,8 @@ help:
 	@echo ''
 	@echo 'Perf install targets:'
 	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
-	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
-	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  HINT: use "prefix" or "DESTDIR" to install to a particular'
+	@echo '        path like "make prefix=/usr/local install install-doc"'
 	@echo '  install	- install compiled binaries'
 	@echo '  install-doc	- install *all* documentation'
 	@echo '  install-man	- install manpage documentation'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 802cf54..53dc11e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -601,7 +601,7 @@ endif
 
 # Make the path relative to DESTDIR, not to prefix
 ifndef DESTDIR
-prefix = $(HOME)
+prefix ?= $(HOME)
 endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
-- 
2.0.0


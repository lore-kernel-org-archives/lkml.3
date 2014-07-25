Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbaGYJ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:29:13 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:60376 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759441AbaGYJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:29:12 -0400
Message-ID: <53D22357.9010005@tu-dresden.de>
Date: Fri, 25 Jul 2014 11:28:55 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Default to python version 2
References: <53D135F9.1070104@tu-dresden.de> <1406258045-25726-1-git-send-email-namhyung@kernel.org> <1406258045-25726-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1406258045-25726-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On 2014-07-25 05:14, Namhyung Kim wrote:
> According to PEP 394 recommendation [1], it's more portable to use
> python2 rather than plain python to refer python binary version 2.

I tried to find out how backwards-compatible this is. python2(-config)
was first available in Python 2.7.3 (April 2012), but it is still not
available in 2.6.9 (Oct. 2013). So it might be better to use python2
as default but fall back to python if python2 is not available.

Best,
Thomas

Signed-off-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
---
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f4f7f58..1b1bc9c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -117,8 +117,8 @@ ifdef PARSER_DEBUG
 endif

 ifndef NO_LIBPYTHON
-  override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python)
+  PYTHON2 := $(call get-executable-or-default,PYTHON,python2)
+  override PYTHON := $(if $(PYTHON2),$(PYTHON2),$(call get-executable,python))
   override PYTHON_CONFIG := \
     $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbaGYKYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:24:12 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63458 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874AbaGYKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:24:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Default to python version 2
References: <53D135F9.1070104@tu-dresden.de>
	<1406258045-25726-1-git-send-email-namhyung@kernel.org>
	<1406258045-25726-2-git-send-email-namhyung@kernel.org>
	<53D22357.9010005@tu-dresden.de>
Date: Fri, 25 Jul 2014 19:24:08 +0900
In-Reply-To: <53D22357.9010005@tu-dresden.de> (Thomas Ilsche's message of
	"Fri, 25 Jul 2014 11:28:55 +0200")
Message-ID: <87wqb1ivnb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, 25 Jul 2014 11:28:55 +0200, Thomas Ilsche wrote:
> Hi Kim,
>
> On 2014-07-25 05:14, Namhyung Kim wrote:
>> According to PEP 394 recommendation [1], it's more portable to use
>> python2 rather than plain python to refer python binary version 2.
>
> I tried to find out how backwards-compatible this is. python2(-config)
> was first available in Python 2.7.3 (April 2012), but it is still not
> available in 2.6.9 (Oct. 2013). So it might be better to use python2
> as default but fall back to python if python2 is not available.
>
> Best,
> Thomas
>
> Signed-off-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> ---
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index f4f7f58..1b1bc9c 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -117,8 +117,8 @@ ifdef PARSER_DEBUG
>  endif
>
>  ifndef NO_LIBPYTHON
> -  override PYTHON := \
> -    $(call get-executable-or-default,PYTHON,python)
> +  PYTHON2 := $(call get-executable-or-default,PYTHON,python2)

But wouldn't it set PYTHON2 to python2 even if the system doesn't have
python2 actually?


> +  override PYTHON := $(if $(PYTHON2),$(PYTHON2),$(call get-executable,python))

And then it'll set PYTHON to python2, no?


>    override PYTHON_CONFIG := \
>      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)


I'm thinking about something like below.. but sadly it doesn't work for
me.. hmm.

Thanks,
Namhyung



diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0f4b7fbc4852..60177278a357 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,8 +121,8 @@ ifdef PARSER_DEBUG
 endif
 
 ifndef NO_LIBPYTHON
-  override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python2)
+  PYTHON2 := $(if $(call get-executable,python2),python2,python)
+  override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON2))
   override PYTHON_CONFIG := \
     $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 

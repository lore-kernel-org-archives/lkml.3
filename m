Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3DAWKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:10:00 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63786 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab3DAWJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:09:57 -0400
Subject: Re: [PATCH 04/27] perf tools: Move programs check into
 config/Makefile
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
In-Reply-To: <1364843930-17974-5-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
	 <1364843930-17974-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Apr 2013 07:09:50 +0900
Message-ID: <1364854190.1728.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> Moving programs check into config/Makefile.

[SNIP]

> +RM      = rm -f
> +MKDIR   = mkdir
> +FIND    = find
> +INSTALL = install
> +FLEX    = flex
> +BISON   = bison
> +STRIP  ?= strip

Why does STRIP use "?=" form?

I know you just moved the line, but AFAICS it can be converted to a
normal variable assignment, right?


> @@ -140,14 +140,6 @@ ifneq ($(MAKECMDGOALS),clean)
>  ifneq ($(MAKECMDGOALS),tags)
>  -include config/feature-tests.mak
>  
> -ifeq ($(call get-executable,$(FLEX)),)
> -	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
> -endif
> -
> -ifeq ($(call get-executable,$(BISON)),)
> -	dummy := $(error Error: $(BISON) is missing on this system, please install it)
> -endif
> -
>  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
>  	CFLAGS := $(CFLAGS) -fstack-protector-all
>  endif
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index fe317c2..04bf8ac 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -32,3 +32,13 @@ endif
>  ifeq ($(NO_PERF_REGS),0)
>          BASIC_CFLAGS += -DHAVE_PERF_REGS
>  endif
> +
> +-include config/feature-tests.mak

It seems now it's redundant to include this file?

Thanks,
Namhyung



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3JJF4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:56:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54155 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3JJFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:55:59 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-f3-5256416d0d76
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 07/52] tools/perf/build: Split out feature check: 'volatile-register-var'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-8-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 14:55:57 +0900
In-Reply-To: <1381227082-22039-8-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:37 +0200")
Message-ID: <87d2ndk6tu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:10:37 +0200, Ingo Molnar wrote:
> -ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
> +ifeq ($(feature-volatile-register-var), 1)
>    CFLAGS += -Wvolatile-register-var
>  endif
>  
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index 46b7650..5693299 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -3,6 +3,7 @@ FILES=					\
>  	test-hello			\
>  	test-stackprotector-all		\
>  	test-stackprotector		\
> +	test-volatile-register-var	\
>  	test-libnuma
>  
>  CC := $(CC) -MD
> @@ -22,6 +23,9 @@ test-stackprotector-all:
>  test-stackprotector:
>  	$(BUILD) -Werror -fstack-protector
>  
> +test-volatile-register-var:
> +	$(BUILD) -Werror -Wvolatile-register-var

I'm not sure this test is necessary at all.

The gcc manpage says this warning is enabled by -Wall, and we add -Wall
to CFLAGS before doing feature checks.  So all gcc versions that support
-Wvolatile-register-var enables it by default without this check and
older gcc versions will always fail the feature check.

Thanks,
Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3KEE7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 23:59:49 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60928 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3KEE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 23:59:48 -0500
Message-ID: <52787B3C.4030006@gmail.com>
Date: Mon, 04 Nov 2013 21:59:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
CC: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] tools/perf/build: Fix detection of non-core features
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping. did not see this one in your last push to Ingo.

On 10/29/13, 10:43 AM, David Ahern wrote:
> feature_check needs to be invoked through call, and LDFLAGS may not be set
> so quotes are needed.
>
> Thanks to Jiri for spotting the quotes around LDFLAGS; that one was driving
> me nuts with the upcoming timerfd feature detection.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>   tools/perf/config/Makefile | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 543aa953bab1..c82772207e6e 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -96,7 +96,7 @@ endif
>
>   feature_check = $(eval $(feature_check_code))
>   define feature_check_code
> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS="$(LDFLAGS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>   endef
>
>   feature_set = $(eval $(feature_set_code))
> @@ -233,7 +233,7 @@ CFLAGS += -I$(LIB_INCLUDE)
>   CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
>
>   ifndef NO_BIONIC
> -  $(feature_check,bionic)
> +  $(call feature_check,bionic)
>     ifeq ($(feature-bionic), 1)
>       BIONIC := 1
>       EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
> @@ -470,15 +470,15 @@ else
>       CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
>     else
>       ifneq ($(feature-libbfd), 1)
> -      $(feature_check,liberty)
> +      $(call feature_check,liberty)
>         ifeq ($(feature-liberty), 1)
>           EXTLIBS += -lbfd -liberty
>         else
> -        $(feature_check,liberty-z)
> +        $(call feature_check,liberty-z)
>           ifeq ($(feature-liberty-z), 1)
>             EXTLIBS += -lbfd -liberty -lz
>           else
> -          $(feature_check,cplus-demangle)
> +          $(call feature_check,cplus-demangle)
>             ifeq ($(feature-cplus-demangle), 1)
>               EXTLIBS += -liberty
>               CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
>


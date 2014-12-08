Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaLHIHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:07:47 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33161 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:07:45 -0500
MIME-Version: 1.0
In-Reply-To: <1417623842-14331-2-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org> <1417623842-14331-2-git-send-email-jolsa@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 8 Dec 2014 17:07:23 +0900
X-Google-Sender-Auth: an4T2ROVLIXsPYfYYIc35bUUbAk
Message-ID: <CAM9d7cixHgGqiLu0c8zrbEU6aLNdvhwC0vne4zcd8OZjQkCV1Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf tools: Add feature check for libbabeltrace
To: Jiri Olsa <jolsa@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, Dec 4, 2014 at 1:23 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> +ifndef NO_LIBBABELTRACE
> +  # for linking with debug library, run like:
> +  # make DEBUG=1 LIBBABELTRACE_DIR=/opt/libdw/

s/libdw/libbabeltrace/


> +  ifdef LIBBABELTRACE_DIR
> +    LIBBABELTRACE_CFLAGS  := -I$(LIBBABELTRACE_DIR)/include
> +    LIBBABELTRACE_LDFLAGS := -L$(LIBBABELTRACE_DIR)/lib
> +  endif
> +  FEATURE_CHECK_CFLAGS-libbabeltrace := $(LIBBABELTRACE_CFLAGS)
> +  FEATURE_CHECK_LDFLAGS-libbabeltrace := $(LIBBABELTRACE_LDFLAGS) -lbabeltrace-ctf
> +endif
> +
>  # include ARCH specific config
>  -include $(src-perf)/arch/$(ARCH)/Makefile
>
> @@ -201,6 +212,7 @@ CORE_FEATURE_TESTS =                        \
>         stackprotector-all              \
>         timerfd                         \
>         libdw-dwarf-unwind              \
> +       libbabeltrace                   \
>         zlib
>
>  LIB_FEATURE_TESTS =                    \
> @@ -216,6 +228,7 @@ LIB_FEATURE_TESTS =                 \
>         libslang                        \
>         libunwind                       \
>         libdw-dwarf-unwind              \
> +       libbabeltrace                   \
>         zlib
>
>  VF_FEATURE_TESTS =                     \
> @@ -661,6 +674,17 @@ else
>    NO_PERF_READ_VDSOX32 := 1
>  endif
>
> +ifndef NO_LIBBABELTRACE
> +  ifeq ($(feature-libbabeltrace), 0)
> +    msg := $(warning No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-devel/libbabeltrace-dev);

It seems that Ubuntu has libbabeltrace-ctf-dev package.

Thanks,
Namhyung


> +    NO_LIBBABELTRACE := 1
> +  else
> +    CFLAGS += -DHAVE_LIBBABELTRACE_SUPPORT $(LIBBABELTRACE_CFLAGS)
> +    LDFLAGS += $(LIBBABELTRACE_LDFLAGS)
> +    EXTLIBS += -lbabeltrace-ctf
> +  endif
> +endif

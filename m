Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3JJW3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:29:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64194 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3JJW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:29:13 -0400
Message-ID: <52572A34.3040506@gmail.com>
Date: Thu, 10 Oct 2013 16:29:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
References: <20131009070149.GA32023@gmail.com> <20131009143830.GA28369@ghostprotocols.net> <20131009145157.GA27139@gmail.com> <20131010192608.GI28369@ghostprotocols.net> <20131010195014.GJ28369@ghostprotocols.net> <20131010200627.GK28369@ghostprotocols.net> <20131010221322.GA1067@krava.redhat.com>
In-Reply-To: <20131010221322.GA1067@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/13 4:13 PM, Jiri Olsa wrote:
> I still got some warning though:
>    LINK     /tmp/perf/perf
> /tmp/perf/libperf.a(target.o): In function `perf_target__parse_uid':
> /home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:72: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:84: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-redhat-linux/4.7.2/../../../../lib64/libpthread.a(libpthread.o): In function `sem_open':
> (.text+0x67f8): warning: the use of `mktemp' is dangerous, better use `mkstemp'

harmless.


> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 233dd36..9680424 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -504,7 +504,7 @@ else
>     endif
>   endif
>
> -ifndef ($(filter -lbfd,$(EXTLIBS)),)
> +ifneq ($(filter -lbfd,$(EXTLIBS)),)
>     CFLAGS += -DHAVE_LIBBFD_SUPPORT
>   endif
>

Nice find.

Tested-by: David Ahern <dsahern@gmail.com>


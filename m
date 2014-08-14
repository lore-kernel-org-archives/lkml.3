Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaHNKCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaHNKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:02:46 -0400
Date: Thu, 14 Aug 2014 12:02:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Static build of libtraceevent failing on ubuntu13 x86_64
Message-ID: <20140814100235.GA10997@krava.brq.redhat.com>
References: <20140813225438.GM2718@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813225438.GM2718@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 07:54:38PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

>   FLEX     util/parse-events-flex.c
>   CC       util/pmu.o
>   CC       util/pmu-flex.o
>   CC       util/parse-events.o
>   CC       util/parse-events-flex.o
>   AR       libperf.a
>   LINK     perf
> /home/acme/git/linux/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
> /home/acme/git/linux/tools/lib/traceevent/event-plugin.c:256: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x191b): warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x1978): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> libperf.a(target.o): In function `target__parse_uid':
> /home/acme/git/linux/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/acme/git/linux/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libnuma.a(affinity.o): In function `affinity_ip':
> (.text+0x765): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `bfd_compress_section_contents':
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:100: undefined reference to `compressBound'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:106: undefined reference to `compress'

hm, those seem to be from zlib ... found similar error here:
http://stackoverflow.com/questions/7906152/error-while-building-binutils-2-21-1a-on-solaris
due to zlib inclusion in bfd lib

jirka

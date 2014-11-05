Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaKEC7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:59:24 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:33622 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaKEC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:59:23 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf tools: Add gzip decompression support for kernel module
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
	<1415063674-17206-3-git-send-email-namhyung@kernel.org>
	<20141104110017.GB20829@krava.brq.redhat.com>
	<20141104134229.GF18464@kernel.org>
Date: Wed, 05 Nov 2014 11:59:21 +0900
In-Reply-To: <20141104134229.GF18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Tue, 4 Nov 2014 10:42:29 -0300")
Message-ID: <87h9yexshi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 10:42:29 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 04, 2014 at 12:00:17PM +0100, Jiri Olsa escreveu:
>> On Tue, Nov 04, 2014 at 10:14:28AM +0900, Namhyung Kim wrote:
>> > Now my Archlinux box shows module symbols correctly.
>> 
>> with the last comment addressed (-lz in test-all.bin):
>> 
>> Acked-by: Jiri Olsa <jolsa@kernel.org>
>
> Thanks, applied the series.

Oh-oh, wait.  I need to add -lz to test-all.bin target in Makefile so
you need to apply this hunk, sorry. :-/


diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Mak
efile
index 7c68ec74a808..53f19b5dbc37 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -41,7 +42,7 @@ BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 ###############################
 
 test-all.bin:
-       $(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+       $(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz
 
 test-hello.bin:
        $(BUILD)


I pushed this to 'perf/vmlinux-v7' branch.  Please check it there.

Thanks,
Namhyung

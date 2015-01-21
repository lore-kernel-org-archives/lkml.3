Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbbAUSvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:51:39 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43197 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbAUSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:51:30 -0500
Message-ID: <54BFF557.1070809@gmail.com>
Date: Wed, 21 Jan 2015 11:52:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/36] perf build: Add builtin objects building
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org> <1421771973-6022-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-9-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/15 9:39 AM, Jiri Olsa wrote:
> Move the rest of builtin objects (bench and test are
> already in) building under build framework.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>   tools/perf/Build           | 29 +++++++++++++++++++++++++++++
>   tools/perf/Makefile.perf   | 35 -----------------------------------
>   tools/perf/config/Makefile |  4 ++++
>   3 files changed, 33 insertions(+), 35 deletions(-)

This one fails to build:

$ git --no-pager log --oneline -1
cd2a9b144028 perf build: Add builtin objects building

$ make O=/tmp/junk
...
builtin-help.c:10:25: fatal error: common-cmds.h: No such file or directory
compilation terminated.
   CC       /tmp/junk/fs/fs.o
   CC       /tmp/junk/builtin-script.o
   CC       /tmp/junk/builtin-kmem.o
   CC       /tmp/junk/perf-read-vdso32
   CC       /tmp/junk/ui/gtk/browser.o
   CC       /tmp/junk/fd/array.o
   CC       /tmp/junk/ui/gtk/hists.o
   CC       /tmp/junk/builtin-lock.o
make[2]: *** [/tmp/junk/builtin-help.o] Error 1
make[2]: *** Waiting for unfinished jobs....

Probably due to this change:

> @@ -591,18 +568,6 @@ $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
>   $(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
>   	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
>
> -$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
> -		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
> -		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
> -		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
> -
> -$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
> -		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
> -		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
> -		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
> -

David


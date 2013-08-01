Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3HAMDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab3HAMDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:03:16 -0400
Date: Thu, 1 Aug 2013 14:02:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
Message-ID: <20130801120251.GB1032@krava.brq.redhat.com>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:18:57PM +0900, Namhyung Kim wrote:
> This patchset implements a front-end tool for kernel's ftrace.  It
> uses function_graph tracer by default and normal function tracer is
> also supported.  (Of course you need to enable those tracers in your
> kernel first.)
> 
> v4 changes:
>  * use pid instead of tid for -p option (David)
>  * not to poll() for reading ftrace pipes (Jiri)
>  * rename to create_perf_header() (Jiri)
>  * canonicalize directory name (Jiri)
>  * show more info when -D option was given (Jiri)
>  * update documentation (Jiri)
>  * and few more bug fixes
> 
> I pushed it out to 'perf/ftrace-v4' branch on my tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> 
> Any comments are welcome, thanks,
> Namhyung

hi,
I've got following error when compiling on Fedora 16:

        CC builtin-ftrace.o
    builtin-ftrace.c: In function ‘set_tracing_clock’:
    builtin-ftrace.c:197:14: error: declaration of ‘clock’ shadows a global declaration [-Werror=shadow]
    builtin-ftrace.c: In function ‘canonicalize_directory_name’:
    builtin-ftrace.c:350:53: error: declaration of ‘dirname’ shadows a global declaration [-Werror=shadow]
    cc1: all warnings being treated as errors

Fedora 17 seems to be ok.. strange ;-)

jirka

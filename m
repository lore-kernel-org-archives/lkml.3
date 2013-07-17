Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3GQUKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:10:10 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:48061 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3GQUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:10:09 -0400
Date: Wed, 17 Jul 2013 17:10:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V7 01/14] perf tools: add debug prints
Message-ID: <20130717201000.GB31906@ghostprotocols.net>
References: <1374064994-17810-1-git-send-email-adrian.hunter@intel.com>
 <1374064994-17810-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374064994-17810-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 17, 2013 at 03:43:01PM +0300, Adrian Hunter escreveu:
> It is useful to see the arguments to perf_event_open
> and whether the perf events ring buffer was mmapped
> per-cpu or per-thread.  That information will now be
> displayed when verbose is 2 i.e option -vv
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Please use 'perf test' before sending patchkits:

[root@zoo ~]# perf test
<SNIP>
14: Test matching and linking multiple hists               : Ok
15: Try 'use perf' in python, checking link problems       : FAILED!
16: Test breakpoint overflow signal handler                : FAILED!
17: Test breakpoint overflow sampling                      : FAILED!
18: Test number of exit event of a simple workload         : Ok
19: Test software clock events have valid period values    : Ok
[root@zoo ~]# 
[root@zoo ~]# perf test 15
15: Try 'use perf' in python, checking link problems       : FAILED!
[root@zoo ~]# set -o vi
[root@zoo ~]# perf test -v 15
15: Try 'use perf' in python, checking link problems       :
--- start ---
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: /tmp/build/perf/python/perf.so: undefined symbol: verbose
---- end ----
Try 'use perf' in python, checking link problems: FAILED!
[root@zoo ~]# 


	The python binding only links a subset of the tools/perf/util/ objects
and is an exercise in trying to modularize the functions so that we don't
drag the whole world into it or in any other libraries we come up with.

	Perhaps in this case we need to make the 'verbose' variable
available in one of the object files already in the link kit for the
python binding or plain pass verbose as a parameter to this function. I
tend to prefer the later, to avoid having a tools/utils wide global.

- Arnaldo

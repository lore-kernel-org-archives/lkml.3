Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3GRKhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:37:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:13567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab3GRKhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="372452691"
Message-ID: <51E7C6F1.3060407@intel.com>
Date: Thu, 18 Jul 2013 13:44:01 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V7 01/14] perf tools: add debug prints
References: <1374064994-17810-1-git-send-email-adrian.hunter@intel.com> <1374064994-17810-2-git-send-email-adrian.hunter@intel.com> <20130717201000.GB31906@ghostprotocols.net>
In-Reply-To: <20130717201000.GB31906@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/13 23:10, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 17, 2013 at 03:43:01PM +0300, Adrian Hunter escreveu:
>> It is useful to see the arguments to perf_event_open
>> and whether the perf events ring buffer was mmapped
>> per-cpu or per-thread.  That information will now be
>> displayed when verbose is 2 i.e option -vv
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> Please use 'perf test' before sending patchkits:

Sorry.  I was running it but in the wrong directory, so it always failed -
being unable to find python/perf.so.  I just assumed it was because I did
not have Python configured correctly and did not look further.

> 
> [root@zoo ~]# perf test
> <SNIP>
> 14: Test matching and linking multiple hists               : Ok
> 15: Try 'use perf' in python, checking link problems       : FAILED!
> 16: Test breakpoint overflow signal handler                : FAILED!
> 17: Test breakpoint overflow sampling                      : FAILED!
> 18: Test number of exit event of a simple workload         : Ok
> 19: Test software clock events have valid period values    : Ok
> [root@zoo ~]# 
> [root@zoo ~]# perf test 15
> 15: Try 'use perf' in python, checking link problems       : FAILED!
> [root@zoo ~]# set -o vi
> [root@zoo ~]# perf test -v 15
> 15: Try 'use perf' in python, checking link problems       :
> --- start ---
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> ImportError: /tmp/build/perf/python/perf.so: undefined symbol: verbose
> ---- end ----
> Try 'use perf' in python, checking link problems: FAILED!
> [root@zoo ~]# 
> 
> 
> 	The python binding only links a subset of the tools/perf/util/ objects
> and is an exercise in trying to modularize the functions so that we don't
> drag the whole world into it or in any other libraries we come up with.
> 
> 	Perhaps in this case we need to make the 'verbose' variable
> available in one of the object files already in the link kit for the
> python binding or plain pass verbose as a parameter to this function. I
> tend to prefer the later, to avoid having a tools/utils wide global.

It is not just 'verbose'.  It is also 'eprintf' due to 'pr_debug'.
Providing an alternative implementation seemed the best approach
- see V8 of the patchset.


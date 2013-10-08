Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3JHMvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:51:20 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38097 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3JHMvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:51:17 -0400
Date: Tue, 8 Oct 2013 14:51:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using
 system wide or CPU options
Message-ID: <20131008125113.GB3438@gmail.com>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
 <1380400080-9211-3-git-send-email-dsahern@gmail.com>
 <87li2eofvd.fsf@sejong.aot.lge.com>
 <52497F3C.9070908@gmail.com>
 <20131008123928.GA4018@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008123928.GA4018@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Sep 30, 2013 at 07:40:12AM -0600, David Ahern escreveu:
> > On 9/30/13 2:47 AM, Namhyung Kim wrote:
> > >>@@ -1517,8 +1517,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
> > >>  	} else if (big_num_opt == 0) /* User passed --no-big-num */
> > >>  		big_num = false;
> > >>
> > >>-	if (!argc && !perf_target__has_task(&target))
> > >>+	if (!argc && !perf_target__has_task(&target) &&
> > >>+	    !perf_target__has_cpu(&target))
> > >
> > >You can use perf_target__none() for this.
> > 
> > Indeed. Updated patch attached.
> 
> Cool patch, applying to acme/perf/core.
> 
> While trying it noticed this, that should also be fixed
> eventually:
> 
> [root@zoo ~]# perf stat -c C 0
> C: No such file or directory
> 
>  Performance counter stats for 'C 0':
> 
>      <not counted> task-clock              
>      <not counted> context-switches        
>      <not counted> cpu-migrations 
> <SNIP>

Btw., would anyone be interested in adding CPU and node binding options to 
perf stat?

There's code to do something like that in tools/perf/bench/numa.c:

        /* Special option string parsing callbacks: */
        OPT_CALLBACK('C', "cpus", NULL, "cpu[,cpu2,...cpuN]",
                        "bind the first N tasks to these specific cpus (the rest is unbound)",
                        parse_cpus_opt),
        OPT_CALLBACK('M', "memnodes", NULL, "node[,node2,...nodeN]",
                        "bind the first N tasks to these specific memory nodes (the rest is unbound)",
                        parse_nodes_opt),

Thanks,

	Ingo

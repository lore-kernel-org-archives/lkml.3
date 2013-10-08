Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3JHN13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:27:29 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:39683 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHN11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:27:27 -0400
Date: Tue, 8 Oct 2013 10:27:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using
 system wide or CPU options
Message-ID: <20131008132720.GD4018@ghostprotocols.net>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
 <1380400080-9211-3-git-send-email-dsahern@gmail.com>
 <87li2eofvd.fsf@sejong.aot.lge.com>
 <52497F3C.9070908@gmail.com>
 <20131008123928.GA4018@ghostprotocols.net>
 <20131008125113.GB3438@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008125113.GB3438@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 08, 2013 at 02:51:13PM +0200, Ingo Molnar escreveu:
> Btw., would anyone be interested in adding CPU and node binding options to 
> perf stat?
> 
> There's code to do something like that in tools/perf/bench/numa.c:
> 
>         /* Special option string parsing callbacks: */
>         OPT_CALLBACK('C', "cpus", NULL, "cpu[,cpu2,...cpuN]",
>                         "bind the first N tasks to these specific cpus (the rest is unbound)",
>                         parse_cpus_opt),
>         OPT_CALLBACK('M', "memnodes", NULL, "node[,node2,...nodeN]",
>                         "bind the first N tasks to these specific memory nodes (the rest is unbound)",
>                         parse_nodes_opt),

As a convenience to using:

	taskset -c cpu-list perf stat -C cpu-list workload

?

- Arnaldo

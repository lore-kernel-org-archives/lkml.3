Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab3JDGCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:02:31 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55904 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JDGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:02:30 -0400
Date: Fri, 4 Oct 2013 08:02:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Petr Benas <pbenas@redhat.com>
Subject: Re: [PATCH] perf: Fix failing assertions in perf bench numa
Message-ID: <20131004060227.GC11399@gmail.com>
References: <1380821325-4017-1-git-send-email-pholasek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380821325-4017-1-git-send-email-pholasek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Petr Holasek <pholasek@redhat.com> wrote:

> Patch adds more subtle handling of -C and -N parameters in
> parse_{cpu,node}_setup_list() functions when there isn't enough NUMA nodes or
> CPUs present.
> Instead of assertion and terminating benchmark, partial test is skipped
> with error message and perf will continue to the next one.
> 
> Fixed problem can be easily reproduced on machine with only one NUMA node:
> 
>  # Running numa/mem benchmark...
> 
>   # Running main, "perf bench numa mem -a"
> 
> ...
> 
>  # Running RAM-bw-remote, "perf bench numa mem -p 1 -t 1 -P 1024 -C 0 -M 1 -s
> perf: bench/numa.c:622: parse_setup_node_list: Assertion `!(bind_node_0 < 0 ||
> 		bind_node_0 >= g->p.nr_nodes)' failed.
> Aborted
> 
> Signed-off-by: Petr Benas <pbenas@redhat.com>
> Signed-off-by: Petr Holasek <pholasek@redhat.com>

Thanks Petr!

Acked-by: Ingo Molnar <mingo@kernel.org>

	Ingo

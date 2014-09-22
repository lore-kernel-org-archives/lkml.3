Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaIVO2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaIVO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:28:07 -0400
Date: Mon, 22 Sep 2014 16:27:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5] perf tools: Add call-graph config options
Message-ID: <20140922142749.GF18187@krava.brq.redhat.com>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 01:18:01AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is patchset to add new callchain related config options so that
> users don't need to pass their preference to the cmdline everytime.
> 
> Following config options will be added, and users can set appropriate
> values to ~/.perfconfig file.  Note that the dump-size option is
> meaningful only if record-mode = dwarf.
> 
>   $ cat ~/.perfconfig
>   [call-graph]
>     record-mode = dwarf
>     dump-size = 4096
>     print-type = graph
>     order = callee
>     threshold = 0.5
>     print-limit = 128
>     sort-key = function
> 
>   $ perf record -vg sleep 1
>   callchain: type DWARF
>   callchain: stack dump size 4096
>   mmap size 528384B
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.054 MB perf.data (~2378 samples) ]
>   Looking at the vmlinux_path (7 entries long)
>   Using /lib/modules/3.16.3-1-ARCH/build/vmlinux for symbols
> 
> 
> You can also get this from 'perf/callchain-config-v1' branch on my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> 
> Any comments are welcomed, thanks
> Namhyung
> 
> 
> Namhyung Kim (5):
>   perf hists browser: Fix callchain print bug on TUI
>   perf tools: Move callchain config from record_opts to callchain_param
>   perf tools: Move some callchain parser functions to callchain.c
>   perf tools: Introduce perf_callchain_config()
>   perf tools: Convert {record,top}.call-graph option to
>     call-graph.record-mode

apart from my other comments, for the patchset:

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

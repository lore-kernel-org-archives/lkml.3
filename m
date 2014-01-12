Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbaALPRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:17:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaALPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:17:02 -0500
Date: Sun, 12 Jan 2014 16:16:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf: Implement lbr-as-callgraph v2
Message-ID: <20140112151623.GB1141@krava.brq.redhat.com>
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 11:42:50AM -0800, Andi Kleen wrote:
> This patchkit implements lbr-as-callgraphs in per freport,
> as an alternative way to present LBR information.
> 
> Current perf report does a histogram over the branch edges,
> which is useful to look at basic blocks, but doesn't tell
> you anything about the larger control flow.
> 
> This patchkit adds a new option --branch-history that
> adds the branch paths to the callgraph history instead.
> 
> This allows to reason about individual branch paths leading
> to specific samples.
> 
> Updates to v1:
> - rebased on perf/core
> - fix various issues
> - rename the option to --branch-history
> - various fixes to display the information more concise
> 
> Example output:
> 
>     % perf record -b -g ./tsrc/tcall
>     [ perf record: Woken up 1 times to write data ]
>     [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
>     % perf report --branch-history
>     ...
>         54.91%  tcall.c:6  [.] f2                      tcall
>                 |
>                 |--66.53%-- f2 tcall.c:5
>                 |          |
>                 |          |--70.83%-- f1 tcall.c:11
>                 |          |          f1 tcall.c:10
>                 |          |          main tcall.c:18
>                 |          |          main tcall.c:18
>                 |          |          main tcall.c:17
>                 |          |          main tcall.c:17
>                 |          |          f1 tcall.c:13
>                 |          |          f1 tcall.c:13
>                 |          |          f2 tcall.c:7
>                 |          |          f2 tcall.c:5
>                 |          |          f1 tcall.c:12
>                 |          |          f1 tcall.c:12
>                 |          |          f2 tcall.c:7
>                 |          |          f2 tcall.c:5
>                 |          |          f1 tcall.c:11
> 

got some whitespace issues:

Applying: perf, tools: fix BFD detection on opensuse
Applying: perf, tools: Support handling complete branch stacks as histograms
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:85: space before tab in indent.
                         * We cannot use the header.misc hint to determine whether a
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:86: space before tab in indent.
                         * branch stack address is user, kernel, guest, hypervisor.
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:87: space before tab in indent.
                         * Branches may straddle the kernel/user/hypervisor boundaries.
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:88: space before tab in indent.
                         * Thus, we have to try consecutively until we find a match
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:89: space before tab in indent.
                         * or else, the symbol is unknown
warning: squelched 8 whitespace errors
warning: 13 lines add whitespace errors.
Applying: perf, tools: Add --branch-history option to report v2
Applying: perf, tools: Filter out small loops from LBR-as-call-stack
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:51: trailing whitespace.
                                memmove(l + i, l + i + off, 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:70: trailing whitespace, space before tab in indent.
         *   we may overlap with the real callstack. 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:84: trailing whitespace.
                for (i = 0; i < nr; i++) { 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:98: trailing whitespace.
                        err = add_callchain_ip(machine, thread, parent, 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:104: trailing whitespace.
                                err = add_callchain_ip(machine, thread, 
warning: 5 lines add whitespace errors.
Applying: perf, tools: Enable printing the srcline in the history
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:21: trailing whitespace.
                if (callchain_param.key == CCKEY_ADDRESS && 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:27: trailing whitespace.
                        printed = scnprintf(bf, bfsize, "%s %s", 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:47: trailing whitespace.
                if (callchain_param.key == CCKEY_ADDRESS && 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:54: trailing whitespace.
                        ret += fprintf(fp, "%s %s\n", 
warning: 4 lines add whitespace errors.
Applying: perf, tools: Fix max stack handling with lbr-as-callgraph
Applying: perf, tools: Add overlap detection for report branch-call-stack mode
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:39: trailing whitespace.
                                /* 
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:42: trailing whitespace.
                                 * the branch entry. To adjust for this 
warning: 2 lines add whitespace errors.
Applying: perf, tools: Only print base source file for srcline
Applying: perf, tools: Support source line numbers in annotate
/home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch:24: trailing whitespace.
                if (dl->line_nr && annotate_browser__opts.show_linenr) 
warning: 1 line adds whitespace errors.


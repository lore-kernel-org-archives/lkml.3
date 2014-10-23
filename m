Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaJWUda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:33:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:49386 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbaJWUd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:33:29 -0400
Date: Thu, 23 Oct 2014 17:33:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCHSET 0/5] perf tools: option parsing improvement
Message-ID: <20141023203325.GL14687@kernel.org>
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 23, 2014 at 12:15:44AM +0900, Namhyung Kim escreveu:
> Hello,
> 
> This patchset tries to enhance option parser a bit.  Patch 1-3 are to
> reuse existing perf record options for other commands like perf kvm
> stat record.  Patch 4-5 are to support exclusive options that cannot
> be used at the same time.  The perf probe has such options and upcoming
> sdt-cache command also.
> 
> You can get it from 'perf/option-share-v2' branch on my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks
> Namhyung

Thanks, applied the series.

- Arnaldo
 
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
> Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> 
> 
> Namhyung Kim (5):
>   perf tools: Add PARSE_OPT_DISABLED flag
>   perf tools: Export usage string and option table of perf record
>   perf kvm: Print kvm specific --help output
>   perf tools: Add support for exclusive option
>   perf probe: Use PARSE_OPT_EXCLUSIVE flag
> 
>  tools/perf/builtin-kvm.c        | 25 +++++++++++++
>  tools/perf/builtin-probe.c      | 54 +++++-----------------------
>  tools/perf/builtin-record.c     |  7 ++--
>  tools/perf/builtin-script.c     |  1 -
>  tools/perf/builtin-timechart.c  |  7 ++--
>  tools/perf/perf.h               |  3 ++
>  tools/perf/util/parse-options.c | 78 ++++++++++++++++++++++++++++++++++-------
>  tools/perf/util/parse-options.h |  4 +++
>  8 files changed, 116 insertions(+), 63 deletions(-)
> 
> -- 
> 2.0.0

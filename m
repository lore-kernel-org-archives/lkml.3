Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaKKRT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:19:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaKKRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:19:23 -0500
Date: Tue, 11 Nov 2014 18:19:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141111171917.GN10501@worktop.programming.kicks-ass.net>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard>
 <20141107173718.GD29390@twins.programming.kicks-ass.net>
 <87mw7zva3c.fsf@sejong.aot.lge.com>
 <20141110121105.GL3337@twins.programming.kicks-ass.net>
 <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
 <20141111102745.GJ10501@worktop.programming.kicks-ass.net>
 <20141111130326.GT18464@kernel.org>
 <20141111140200.GV18464@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111140200.GV18464@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 11:02:00AM -0300, Arnaldo Carvalho de Melo wrote:
> Can you try the patch below?
> 

> diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
> index c9541fea9514..b55f96d49503 100644
> --- a/tools/perf/util/symbol-minimal.c
> +++ b/tools/perf/util/symbol-minimal.c
> @@ -341,7 +341,7 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>  
>  	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
>  		dso__set_build_id(dso, build_id);
> -		return 1;
> +		return 0;
>  	}
>  	return 0;
>  }

removing libelf-dev and recompiling to verify its broken again, then I
made this change, recompiled and tried again and that seems to work.

Control flow seems redundant though, might as well remove the entire
return stmt.

Still wondering why the generic code accepts DSOs without symbols
though. But whatever ;-)

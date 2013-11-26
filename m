Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3KZLbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:31:14 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:64166 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3KZLbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:31:12 -0500
Date: Tue, 26 Nov 2013 12:31:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Fix tags target rebuilding
Message-ID: <20131126113108.GE2410@gmail.com>
References: <1385464890-19876-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385464890-19876-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> Once the tags file is generated it's never rebuilt
> until it's removed by hand.
> 
> The reason is that the Makefile does not treat tags
> as a target but as a file to be rebuilt.
> 
> Adding tags as PHONY target into the Makefile.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 4835618..95f5792 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -61,7 +61,7 @@ endef
>  #
>  # Needed if no target specified:
>  #
> -all:
> +all tags:

Obviously the change invalidates the comment above.

>  	$(print_msg)
>  	$(make)
>  
> @@ -77,3 +77,5 @@ clean:
>  %:
>  	$(print_msg)
>  	$(make)
> +
> +.PHONY: tags

Note that there's also a TAGS file that uses etags - which probably 
needs similar treatment.

Also note that we have duplicate code for this in Makefile.perf 
already. Would it be possible to pass through this there and keep the 
main Makefile is just a thin, minimal wrapper that adds default 
parallelism, etc?

Thanks,

	Ingo

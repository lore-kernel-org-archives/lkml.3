Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbaGRFEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:04:55 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41976 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaGRFEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:04:54 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 4/5] perf tools: Add --debug optionto set debug variable
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
	<1405374411-29012-5-git-send-email-jolsa@kernel.org>
	<87wqbc1juy.fsf@sejong.aot.lge.com>
	<20140717105500.GG516@krava.redhat.com>
Date: Fri, 18 Jul 2014 14:04:51 +0900
In-Reply-To: <20140717105500.GG516@krava.redhat.com> (Jiri Olsa's message of
	"Thu, 17 Jul 2014 12:55:00 +0200")
Message-ID: <87ha2fl0jw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 17 Jul 2014 12:55:00 +0200, Jiri Olsa wrote:
> yep, it's better, v3 attached

[SNIP]
> --- a/tools/perf/Documentation/perf.txt
> +++ b/tools/perf/Documentation/perf.txt
> @@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
>  SYNOPSIS
>  --------
>  [verse]
> -'perf' [--version] [--help] COMMAND [ARGS]
> +'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]
> +
> +OPTIONS
> +-------
> +--debug::
> +	Setup debug variable (just verbose for now) in value
> +	range (0, 10). Use like:
> +	  --debug verbose   # sets verbose = 1
> +	  --debug verbose=2 # sets verbose = 2
>  
>  DESCRIPTION
>  -----------
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 95c58fc15284..eed3fb2a3af0 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -13,11 +13,12 @@
>  #include "util/quote.h"
>  #include "util/run-command.h"
>  #include "util/parse-events.h"
> +#include "util/debug.h"
>  #include <api/fs/debugfs.h>
>  #include <pthread.h>
>  
>  const char perf_usage_string[] =
> -	"perf [--version] [--help] COMMAND [ARGS]";
> +	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";

You missed to update here.. ;-)

Thanks,
Namhyung

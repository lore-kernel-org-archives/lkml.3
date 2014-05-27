Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaE0BKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:10:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45990 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaE0BKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:10:41 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/14] perf tests: Add test interface for dso data fd limit
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-13-git-send-email-jolsa@kernel.org>
Date: Tue, 27 May 2014 10:10:40 +0900
In-Reply-To: <1400174615-2121-13-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 15 May 2014 19:23:33 +0200")
Message-ID: <87ha4chvqn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 19:23:33 +0200, Jiri Olsa wrote:
> Adding a way to setup test dso limit by global variable
> test_dso_data__fd_limit. It'll be used in the dso data
> cache tests.

Why is this needed?  Why not justing setting RLIMIT_NOFILE in the test
cases?

Thanks,
Namhyung

>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/dso.c | 5 +++++
>  tools/perf/util/dso.h | 3 +++
>  2 files changed, 8 insertions(+)
>
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 80b54e7..9310369 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -7,6 +7,8 @@
>  #include "util.h"
>  #include "debug.h"
>  
> +rlim_t test_dso_data__fd_limit;
> +
>  char dso__symtab_origin(const struct dso *dso)
>  {
>  	static const char origin[] = {
> @@ -262,6 +264,9 @@ static bool may_cache_fd(void)
>  	if (!limit)
>  		limit = get_fd_limit();
>  
> +	if (unlikely(test_dso_data__fd_limit))
> +		limit = test_dso_data__fd_limit;
> +
>  	if (limit == RLIM_INFINITY)
>  		return true;
>  
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index d713184..3807014 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -1,6 +1,7 @@
>  #ifndef __PERF_DSO
>  #define __PERF_DSO
>  
> +#include <sys/resource.h>
>  #include <linux/types.h>
>  #include <linux/rbtree.h>
>  #include <stdbool.h>
> @@ -8,6 +9,8 @@
>  #include "map.h"
>  #include "build-id.h"
>  
> +extern rlim_t test_dso_data__fd_limit;
> +
>  enum dso_binary_type {
>  	DSO_BINARY_TYPE__KALLSYMS = 0,
>  	DSO_BINARY_TYPE__GUEST_KALLSYMS,

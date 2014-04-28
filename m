Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaD1PCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:02:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43235 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbaD1PCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:02:00 -0400
Message-ID: <535E6D65.80909@gmail.com>
Date: Mon, 28 Apr 2014 09:01:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: Fix bfd dependency libraries detection
References: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/14, 3:22 AM, Jiri Olsa wrote:
> From: Jiri Olsa <jolsa@redhat.com>
>
> There's false assumption in the library detection code
> assuming -liberty and -lz are always present once bfd
> is detected. The fails on Ubuntu (14.04) as reported
> by Ingo.
>
> Forcing the bdf dependency libraries detection any
> time bfd library is detected.

Have you tried static builds? I need to do those occasionally and I 
always have to muck around with the Makefiles to get it to succeed -- 
something with the -liberty and bfd checks.

>
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Tested-by: Ingo Molnar <mingo@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/perf/config/Makefile | 34 +++++++++++++++++++++++-----------
>   1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index a71fb39..a57d59e 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -194,7 +194,10 @@ VF_FEATURE_TESTS =			\
>   	stackprotector-all		\
>   	timerfd				\
>   	libunwind-debug-frame		\
> -	bionic
> +	bionic				\
> +	liberty				\
> +	liberty-z			\
> +	cplus-demangle
>
>   # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
>   # If in the future we need per-feature checks/flags for features not
> @@ -512,7 +515,21 @@ else
>   endif
>
>   ifeq ($(feature-libbfd), 1)
> -  EXTLIBS += -lbfd -lz -liberty
> +  EXTLIBS += -lbfd
> +
> +  # call all detections now so we get correct
> +  # status in VF output

Are you folding the "VF" into V?

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3FSOwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:52:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39336 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab3FSOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:52:11 -0400
Message-ID: <51C1C596.10405@gmail.com>
Date: Wed, 19 Jun 2013 08:52:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 3/3] perf tools: include termios.h explicitly
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com> <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/13 7:02 PM, Joonsoo Kim wrote:
> Building perf for android is failed, because it can't find definition of
> struct winsize. This definition is in termios.h, so I add this header
> to util.h to solve the problem. It is missed by commit '2c803e52' which
> moves get_term_dimensions() from builtin-top.c to util.c, but, missed to
> move termios.h header.

Thank you for fixing this.

David

>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index a45710b..f2c6483 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -72,6 +72,7 @@
>   #include "types.h"
>   #include <sys/ttydefaults.h>
>   #include <lk/debugfs.h>
> +#include <termios.h>
>
>   extern const char *graph_line;
>   extern const char *graph_dotted_line;
> @@ -274,6 +275,5 @@ void dump_stack(void);
>
>   extern unsigned int page_size;
>
> -struct winsize;
>   void get_term_dimensions(struct winsize *ws);
>   #endif /* GIT_COMPAT_UTIL_H */
>


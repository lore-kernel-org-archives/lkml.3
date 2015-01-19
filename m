Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbbASKob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:44:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:42782 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbASKoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:44:30 -0500
Message-ID: <54BCDF89.5070008@huawei.com>
Date: Mon, 19 Jan 2015 18:42:17 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <acme@kernel.org>, <jolsa@redhat.com>
CC: <paulus@samba.org>, <mingo@redhat.com>, <namhyung@kernel.org>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] perf: perl: force to use stdbool.
References: <1421301354-58012-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1421301354-58012-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Jiri Olsa jolsa@kernel.org to CC list. I think jolsa@kernel.org should be the main
email address he uses.

On 2015/1/15 13:55, Wang Nan wrote:
> When building perf for arm64 I hit a warning (and be treated as an
> error) like below:
> 
>  aarch64-oe-linux-gcc -o .../util/scripting-engines/trace-event-python.o -c -Wbad-function-cast \
> 	 ... util/scripting-engines/trace-event-python.c
> 
>  In file included from .../usr/lib64/perl/5.14.3/CORE/perl.h:2464:0,
>                   from Context.xs:23:
>  /.../usr/lib64/perl/5.14.3/CORE/handy.h:108:0: error: "bool" redefined [-Werror]
>   #  define bool char
>   ^
>  In file included from /.../usr/src/kernel/tools/include/linux/types.h:4:0,
>                   from /.../usr/src/kernel/arch/arm64/include/uapi/asm/sigcontext.h:19,
> 		  from /.../usr/include/bits/sigcontext.h:27,
> 		  from /.../usr/include/signal.h:340,
> 		  from /.../usr/include/sys/param.h:28,
> 		  from /.../usr/lib64/perl/5.14.3/CORE/perl.h:678,
> 		  from Context.xs:23:
>   /.../usr/lib/aarch64-oe-linux/gcc/aarch64-oe-linux/4.9.2/include/stdbool.h:33:0: note: this is the location of the previous definition
>     #define bool _Bool
> 
> Looks like the failure is caused by arm64 uapi/asm/sigcontext.h, which
> includes linux/types.h while other archs not.
> 
> This patch includes stdbool.h before Context.xs and define HAS_BOOL to
> prevent perl'e headers define its own 'bool'.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> index 790ceba..69c3572 100644
> --- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> @@ -5,7 +5,8 @@
>   *	ANY CHANGES MADE HERE WILL BE LOST! 
>   *
>   */
> -
> +#include <stdbool.h>
> +#define HAS_BOOL 1
>  #line 1 "Context.xs"
>  /*
>   * Context.xs.  XS interfaces for perf script.
> 



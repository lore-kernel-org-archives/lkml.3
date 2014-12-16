Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLPEtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:49:01 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54958 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLPEtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:49:00 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 16 Dec 2014 13:49:09 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, ak@linux.intel.com, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix building warning on ARM 32.
Message-ID: <20141216044909.GA20215@sejong>
References: <1418695810-74455-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418695810-74455-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On Tue, Dec 16, 2014 at 10:10:10AM +0800, Wang Nan wrote:
> Commit 85c116a6c introduces asprintf() call and matches '%ld' to a u64
> argument, which is incorrect on ARM.
> 
>    CC       /home/wn/util/srcline.o
>  util/srcline.c: In function 'get_srcline':
>  util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
>  cc1: all warnings being treated as errors
>  make[1]: *** [/home/wn/util/srcline.o] Error 1

Hmm.. shouldn't it be %PRIu64 instead?

Thanks,
Namhyung


> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/perf/util/srcline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
> index e73b6a5..42cb642 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/perf/util/srcline.c
> @@ -294,7 +294,7 @@ out:
>  	}
>  	if (sym) {
>  		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
> -					addr - sym->start) < 0)
> +					(long int)(addr - sym->start)) < 0)
>  			return SRCLINE_UNKNOWN;
>  	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
>  		return SRCLINE_UNKNOWN;
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

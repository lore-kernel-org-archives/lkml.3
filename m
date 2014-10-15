Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaJOPOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:14:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:51503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaJOPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:14:05 -0400
Date: Wed, 15 Oct 2014 12:13:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        zhangzhiqiang.zhang@huawei.com, peifeiyue@huawei.com
Subject: Re: [PATCH] perf tools: fix incorrect header string
Message-ID: <20141015151358.GK3198@kernel.org>
References: <1413343733-7973-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413343733-7973-1-git-send-email-wangnan0@huawei.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 15, 2014 at 11:28:53AM +0800, Wang Nan escreveu:
> Commit fbe96f29 (perf tools: Make perf.data more self-descriptive)
> read '/proc/cpuinfo' to form cpu descriptor. For ARM, it finds
> 'Processor' field. It is correct when the patch merged, but due to
> commit b4b8f770 (ARM: kernel: update cpuinfo to print all online CPUs
> features), the corresponding information becomes 'model name' field.
> 
> This patch simply corrects it.

It doesn't :-)

It makes it work with kernels >= b4b8f770, and fail with older kernels.

We need to somehow figure out where the right information is regardless
of the kernel.

- Arnaldo
 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/perf/perf-sys.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
> index 937e432..4293970 100644
> --- a/tools/perf/perf-sys.h
> +++ b/tools/perf/perf-sys.h
> @@ -113,7 +113,7 @@
>  #define mb()		((void(*)(void))0xffff0fa0)()
>  #define wmb()		((void(*)(void))0xffff0fa0)()
>  #define rmb()		((void(*)(void))0xffff0fa0)()
> -#define CPUINFO_PROC	"Processor"
> +#define CPUINFO_PROC	"model name"
>  #endif
>  
>  #ifdef __aarch64__
> -- 
> 1.8.4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CYR6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:58:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab3CYR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:58:49 -0400
Message-ID: <1364234218.2334.2.camel@t520.redhat.com>
Subject: Re: [RFC PATCH v2, part4 03/39] c6x: normalize global variables
 exported by vmlinux.lds
From: Mark Salter <msalter@redhat.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Mon, 25 Mar 2013 13:56:58 -0400
In-Reply-To: <1364109934-7851-4-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
	 <1364109934-7851-4-git-send-email-jiang.liu@huawei.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-24 at 15:24 +0800, Jiang Liu wrote:
> Normalize global variables exported by vmlinux.lds to conform usage
> guidelines from include/asm-generic/sections.h.
> 
> Use _text to mark the start of the kernel image including the head text,
> and _stext to mark the start of the .text section.
> 
> This patch also fixes possible bugs due to current address layout that
> [__init_begin, __init_end] is a sub-range of [_stext, _etext] and pages
> within range [__init_begin, __init_end] will be freed by free_initmem().

I won't have time to look at this in detail until later this week, but
the reason for that layout is because c6x commonly stores text in flash.
Not all of the xip support is in-tree yet, but when it is, we don't want
to free init text.

--Mark

> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/c6x/kernel/vmlinux.lds.S |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/c6x/kernel/vmlinux.lds.S b/arch/c6x/kernel/vmlinux.lds.S
> index 1d81c4c..279d807 100644
> --- a/arch/c6x/kernel/vmlinux.lds.S
> +++ b/arch/c6x/kernel/vmlinux.lds.S
> @@ -54,16 +54,15 @@ SECTIONS
>  	}
>  
>  	. = ALIGN(PAGE_SIZE);
> +	__init_begin = .;
>  	.init :
>  	{
> -		_stext = .;
>  		_sinittext = .;
>  		HEAD_TEXT
>  		INIT_TEXT
>  		_einittext = .;
>  	}
>  
> -	__init_begin = _stext;
>  	INIT_DATA_SECTION(16)
>  
>  	PERCPU_SECTION(128)
> @@ -74,6 +73,7 @@ SECTIONS
>  	.text :
>  	{
>  		_text = .;
> +		_stext = .;
>  		TEXT_TEXT
>  		SCHED_TEXT
>  		LOCK_TEXT



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231AbaKNM6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:58:44 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46544 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaKNM6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:58:43 -0500
Date: Fri, 14 Nov 2014 21:59:00 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org,
        sergey.senozhatsky@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/zsmalloc: add __init/__exit to zs_init/zs_exit
Message-ID: <20141114125900.GA1007@swordfish>
References: <1415885857-5283-1-git-send-email-opensource.ganesh@gmail.com>
 <1415885857-5283-2-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415885857-5283-2-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/13/14 21:37), Mahendran Ganesh wrote:
> After patch [1], the zs_exit is only called in module exit.
> So add __init/__exit to zs_init/zs_exit.
> 
>   [1] mm/zsmalloc: avoid unregister a NOT-registered zsmalloc zpool driver
> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>

makes sense.

	-ss

> ---
>  mm/zsmalloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 3d2bb36..92af030 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -881,7 +881,7 @@ static struct notifier_block zs_cpu_nb = {
>  	.notifier_call = zs_cpu_notifier
>  };
>  
> -static void zs_exit(void)
> +static void __exit zs_exit(void)
>  {
>  	int cpu;
>  
> @@ -898,7 +898,7 @@ static void zs_exit(void)
>  	cpu_notifier_register_done();
>  }
>  
> -static int zs_init(void)
> +static int __init zs_init(void)
>  {
>  	int cpu, ret;
>  
> -- 
> 1.7.9.5
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977Ab3DQJnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:43:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42683 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3DQJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:43:30 -0400
X-Spam-Score: -100.7
Message-ID: <516E6E98.4010501@asianux.com>
Date: Wed, 17 Apr 2013 17:42:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: debug: memcpy overlaped, use memmove instead
 of memcpy.
References: <51614951.80606@asianux.com>
In-Reply-To: <51614951.80606@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainers:

  please help check this patch, when you have time, thanks.


On 2013年04月07日 18:24, Chen Gang wrote:
> 
>   in memcpy, src and dest are overlaped.
>     for default implementaion or some architectures, it is OK.
>     but we can not be sure that it is OK for all platforms.
>     and in this condition, the performance are not quite important.
> 
>   so better to use standard ways: let memmove instead of memcpy.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/debug/kdb/kdb_support.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
> index d35cc2d..990b3cc 100644
> --- a/kernel/debug/kdb/kdb_support.c
> +++ b/kernel/debug/kdb/kdb_support.c
> @@ -129,13 +129,13 @@ int kdbnearsym(unsigned long addr, kdb_symtab_t *symtab)
>  		}
>  		if (i >= ARRAY_SIZE(kdb_name_table)) {
>  			debug_kfree(kdb_name_table[0]);
> -			memcpy(kdb_name_table, kdb_name_table+1,
> +			memmove(kdb_name_table, kdb_name_table+1,
>  			       sizeof(kdb_name_table[0]) *
>  			       (ARRAY_SIZE(kdb_name_table)-1));
>  		} else {
>  			debug_kfree(knt1);
>  			knt1 = kdb_name_table[i];
> -			memcpy(kdb_name_table+i, kdb_name_table+i+1,
> +			memmove(kdb_name_table+i, kdb_name_table+i+1,
>  			       sizeof(kdb_name_table[0]) *
>  			       (ARRAY_SIZE(kdb_name_table)-i-1));
>  		}
> 


-- 
Chen Gang

Asianux Corporation

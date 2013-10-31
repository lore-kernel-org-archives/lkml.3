Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3JaNfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:35:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33151 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab3JaNfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:35:52 -0400
Message-ID: <52725CB5.5090903@imgtec.com>
Date: Thu, 31 Oct 2013 13:35:49 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH V2] printk/cache: Mark printk_once test variable __read_mostly
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>  <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org> <1383174102.9435.54.camel@joe-AO722>
In-Reply-To: <1383174102.9435.54.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_31_13_35_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 23:01, Joe Perches wrote:
> Add #include <linux/cache.h> to define __read_mostly.
> 
> Convert cache.h to use uapi/linux/kernel.h instead
> of linux/kernel.h to avoid recursive #includes.
> 
> Convert the ALIGN macro to __KERNEL_ALIGN.
> 
> printk_once only sets the bool variable tested
> once so mark it __read_mostly.
> 
> Neaten the alignment so it matches the rest of the
> pr_<level>_once #defines too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> V2: Add cache.h which was nearly always used
>     indirectly via #include <some_other_file.h>,
>     generally module.h
>     Update cache.h to avoid recursive #include
> 
>  include/linux/cache.h  |  4 ++--
>  include/linux/printk.h | 19 ++++++++++---------
>  2 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/cache.h b/include/linux/cache.h
> index 4c57065..63a1d97 100644
> --- a/include/linux/cache.h
> +++ b/include/linux/cache.h
> @@ -1,11 +1,11 @@
>  #ifndef __LINUX_CACHE_H
>  #define __LINUX_CACHE_H
>  
> -#include <linux/kernel.h>
> +#include <uapi/linux/kernel.h>
>  #include <asm/cache.h>
>  
>  #ifndef L1_CACHE_ALIGN
> -#define L1_CACHE_ALIGN(x) ALIGN(x, L1_CACHE_BYTES)
> +#define L1_CACHE_ALIGN(x) __KERNEL_ALIGN(x, L1_CACHE_BYTES)

I think that should be __ALIGN_KERNEL (same applies to commit message).

Otherwise this patch looks good to me and builds all Meta defconfigs fine.
Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thanks
James


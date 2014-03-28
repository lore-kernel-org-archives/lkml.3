Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaC1KEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:04:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34279 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098AbaC1KEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:04:33 -0400
Date: Fri, 28 Mar 2014 10:04:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3 1/4] kmemleak: free internal objects only if there're
 no leaks to be reported
Message-ID: <20140328100403.GA21330@arm.com>
References: <5335384A.2000000@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335384A.2000000@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:52:26AM +0000, Li Zefan wrote:
> Currently if you disabling kmemleak after stopping kmemleak thread,
> kmemleak objects will be freed and so you won't be able to check
> previously reported leaks.
> 
> With this patch, kmemleak objects won't be freed if there're leaks
> that can be reported.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Some nitpicks below:

> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 31f01c5..be7ecc0 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -218,7 +218,8 @@ static int kmemleak_stack_scan = 1;
>  static DEFINE_MUTEX(scan_mutex);
>  /* setting kmemleak=on, will set this var, skipping the disable */
>  static int kmemleak_skip_disable;
> -
> +/* If there're leaks that can be reported */

"If there are ..." (easier to read ;)).

> +static bool kmemleak_has_leaks;

Better "kmemleak_found_leaks" to avoid confusion.

Otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

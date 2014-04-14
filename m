Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaDNWza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:55:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDNWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:55:28 -0400
Date: Mon, 14 Apr 2014 15:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
Message-Id: <20140414155526.96b0832bf4660c026bc3a1d9@linux-foundation.org>
In-Reply-To: <1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
	<1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2014 10:54:19 -0700 Mitchel Humpherys <mitchelh@codeaurora.org> wrote:

> printk is meant to be used with an associated log level. There are some
> instances of printk scattered around the mm code where the log level is
> missing. Add a log level and adhere to suggestions by
> scripts/checkpatch.pl by moving to the pr_* macros.
> 

hm, this is a functional change.

> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -3,6 +3,8 @@
>   * - Split from highmem.c
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Because of this.

>  #include <linux/mm.h>
>  #include <linux/export.h>
>  #include <linux/swap.h>
> @@ -15,6 +17,7 @@
>  #include <linux/hash.h>
>  #include <linux/highmem.h>
>  #include <linux/bootmem.h>
> +#include <linux/printk.h>
>  #include <asm/tlbflush.h>
>  
>  #include <trace/events/block.h>
> @@ -34,7 +37,7 @@ static __init int init_emergency_pool(void)
>  
>  	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
>  	BUG_ON(!page_pool);
> -	printk("bounce pool size: %d pages\n", POOL_SIZE);
> +	pr_info("bounce pool size: %d pages\n", POOL_SIZE);

This used to print "bounce pool size: N pages" but will now print
"bounce: bounce pool size: N pages".

It isn't necessarily a *bad* change but perhaps a little more thought
could be put into it.  In this example it would be better remove the
redundancy by using 

	pr_info("pool size: %d pages\n"...);

And all of this should be described and justified in the changelog,
please.



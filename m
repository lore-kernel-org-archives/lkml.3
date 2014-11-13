Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaKMCxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:53:41 -0500
Received: from relay.variantweb.net ([104.131.199.242]:53817 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753475AbaKMCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:53:40 -0500
Date: Wed, 12 Nov 2014 20:53:37 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: unregister zswap_cpu_notifier_block in cleanup
 procedure
Message-ID: <20141113025337.GA9068@medulla.variantweb.net>
References: <1415532143-4409-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415532143-4409-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 07:22:23PM +0800, Mahendran Ganesh wrote:
> In zswap_cpu_init(), the code does not unregister *zswap_cpu_notifier_block*
> during the cleanup procedure.

This is not needed.  If we are in the cleanup code, we never got to the
__register_cpu_notifier() call.

Thanks,
Seth

> 
> This patch fix this issue.
> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
> ---
>  mm/zswap.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ea064c1..51a2c45 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -404,6 +404,7 @@ static int zswap_cpu_init(void)
>  cleanup:
>  	for_each_online_cpu(cpu)
>  		__zswap_cpu_notifier(CPU_UP_CANCELED, cpu);
> +	__unregister_cpu_notifier(&zswap_cpu_notifier_block);
>  	cpu_notifier_register_done();
>  	return -ENOMEM;
>  }
> -- 
> 1.7.9.5
> 

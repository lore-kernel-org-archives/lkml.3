Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaF0VFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbaF0VFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:05:38 -0400
Date: Fri, 27 Jun 2014 17:05:12 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm/hwpoison-inject.c: remove unnecessary null test
 before debugfs_remove_recursive
Message-ID: <20140627210512.GA18026@nhori.bos.redhat.com>
References: <1403902696-12162-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403902696-12162-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:58:16PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> "WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required"
> 
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Looks good to me, thank you.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/hwpoison-inject.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index 95487c7..329caf5 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -72,8 +72,7 @@ DEFINE_SIMPLE_ATTRIBUTE(unpoison_fops, NULL, hwpoison_unpoison, "%lli\n");
>  
>  static void pfn_inject_exit(void)
>  {
> -	if (hwpoison_dir)
> -		debugfs_remove_recursive(hwpoison_dir);
> +	debugfs_remove_recursive(hwpoison_dir);
>  }
>  
>  static int pfn_inject_init(void)
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

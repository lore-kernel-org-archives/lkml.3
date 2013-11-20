Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3KTRej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:34:39 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59310 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3KTReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:34:37 -0500
Date: Wed, 20 Nov 2013 18:33:50 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: linux-mm@kvack.org, Seth Jennings <sjennings@variantweb.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: Re: [PATCH] mm/zswap: change params from hidden to ro
Message-ID: <20131120173347.GA2369@hp530>
References: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan!

On Wed, Nov 20, 2013 at 11:38:42AM -0500, Dan Streetman wrote:
> The "compressor" and "enabled" params are currently hidden,
> this changes them to read-only, so userspace can tell if
> zswap is enabled or not and see what compressor is in use.

Could you elaborate more why this pice of information is necessary for
userspace?

Vladimir

> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index d93510c..36b268b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -77,12 +77,12 @@ static u64 zswap_duplicate_entry;
>  **********************************/
>  /* Enable/disable zswap (disabled by default, fixed at boot for now) */
>  static bool zswap_enabled __read_mostly;
> -module_param_named(enabled, zswap_enabled, bool, 0);
> +module_param_named(enabled, zswap_enabled, bool, 0444);
>  
>  /* Compressor to be used by zswap (fixed at boot for now) */
>  #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
>  static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
> -module_param_named(compressor, zswap_compressor, charp, 0);
> +module_param_named(compressor, zswap_compressor, charp, 0444);
>  
>  /* The maximum percentage of memory that the compressed pool can occupy */
>  static unsigned int zswap_max_pool_percent = 20;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

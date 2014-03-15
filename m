Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaCOOW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:22:27 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58750 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaCOOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:22:26 -0400
Date: Sat, 15 Mar 2014 17:18:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] zram: include linux/err.h
Message-ID: <20140315141839.GA361@swordfish>
References: <201403151040.09139.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403151040.09139.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On (03/15/14 10:40), Arnd Bergmann wrote:
> The zram driver uses the ERR_PTR macro defined in <linux/err.h>
> and relies on this header to be included implicitly through
> other headers, which is not (always) the case on the ARM architecture.
> 

returned from zcomp ERR_PTR is checked and used in zram_drv.c, should
in this case there also be inclusion of err.h in zram_drv.h? if so, it
probably makes sense to move inclusion of err.h to zcomp.h, which is
included both in zcomp.c and zram_drv.c

> Adding an explicit #include allows us to build the driver in
> all configurations.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 92a83df..3507bef 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -7,6 +7,7 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> +#include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> 

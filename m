Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbaCTVoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaCTVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:44:43 -0400
Date: Thu, 20 Mar 2014 14:44:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Arnd Bergmann <arnd@arndb.de>, Jerome Marchand <jmarchan@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zram: include err.h in zram_drv
Message-Id: <20140320144441.68662e5efa9c5d6f4abd581e@linux-foundation.org>
In-Reply-To: <1395349323-18838-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1395349323-18838-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 00:02:03 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> zcomp returns error-valued pointer, also include err.h header
> in zram_drv.
> 
> Per Arnd Bergmann:
> The zram driver uses the ERR_PTR macro defined in <linux/err.h>
> and relies on this header to be included implicitly through
> other headers, which is not (always) the case on the ARM architecture.
> 
> ...
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -31,6 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
> +#include <linux/err.h>
>  
>  #include "zram_drv.h"

I can find no occurrence of ERR_PTR in any version of
drivers/block/zram/zram_drv.c which I can find.

zram-return-error-valued-pointer-from-zcomp_create.patch adds IS_ERR to
drivers/block/zram/zram_drv.c which is presumably what you meant.  

zram-return-error-valued-pointer-from-zcomp_create.patch also adds
ERR_PTR() calls into drivers/block/zram/zcomp.c so that file should
include err.h also.


Here's what I added, as
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: include err.h

[akpm@linux-foundation.org: fix zcomp.h as well]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    1 +
 drivers/block/zram/zram_drv.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-include-errh-in-zram_drv drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-include-errh-in-zram_drv
+++ a/drivers/block/zram/zram_drv.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 
 #include "zram_drv.h"
 
diff -puN drivers/block/zram/zcomp.c~zram-include-errh-in-zram_drv drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-include-errh-in-zram_drv
+++ a/drivers/block/zram/zcomp.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
_


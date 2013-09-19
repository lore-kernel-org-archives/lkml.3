Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3ISHR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:17:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3ISHR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:17:27 -0400
Date: Thu, 19 Sep 2013 09:17:20 +0200
From: Borislav Petkov <bp@suse.de>
To: Vinson Lee <vlee@freedesktop.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vinson Lee <vlee@twitter.com>
Subject: Re: [PATCH] tools lib lk: Uninclude linux/magic.h in debugfs.c.
Message-ID: <20130919071720.GA9435@pd.tnic>
References: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:16:40PM -0700, Vinson Lee wrote:
> From: Vinson Lee <vlee@twitter.com>
> 
> The compilation only looks for linux/magic.h from the default include
> paths, which does not include the source tree. This results in a build
> error if linux/magic.h is not available or not installed.

Right, we have:

tools/perf/util/include/linux/magic.h

but tools/lib/lk/Makefile doesn't know about it, it seems. Oh well, the
solution falling back to debugfs.h is even better. :)

> For example, this build error occurs on CentOS 5.
> 
> $ make -C tools/lib/lk V=1
> [...]
> gcc -o debugfs.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6
> -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement
> -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations
> -Wmissing-prototypes -Wnested-externs -Wno-system-headers
> -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow
> -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum
> -Wundef -Wwrite-strings -Wformat  -fPIC  -D_LARGEFILE64_SOURCE
> -D_FILE_OFFSET_BITS=64 debugfs.c
> debugfs.c:8:25: error: linux/magic.h: No such file or directory
> 
> The only symbol from linux/magic.h needed by debugfs.c is DEBUGFS_MAGIC,
> and that is already defined in debugfs.h. linux/magic.h isn't providing
> any extra symbols and can unincluded. This is similar to the approach by
> perf, which has its own magic.h wrapper at
> tools/perf/util/include/linux/magic.h
> 
> Signed-off-by: Vinson Lee <vlee@twitter.com>
> Cc: stable@vger.kernel.org # 3.10+

Acked-by: Borislav Petkov <bp@suse.de>

> ---
>  tools/lib/lk/debugfs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
> index 099e7cd..7c43479 100644
> --- a/tools/lib/lk/debugfs.c
> +++ b/tools/lib/lk/debugfs.c
> @@ -5,7 +5,6 @@
>  #include <stdbool.h>
>  #include <sys/vfs.h>
>  #include <sys/mount.h>
> -#include <linux/magic.h>
>  #include <linux/kernel.h>
>  
>  #include "debugfs.h"
> -- 
> 1.8.2.1
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

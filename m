Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaJTJXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:23:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:50802 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaJTJXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:23:22 -0400
Date: Mon, 20 Oct 2014 12:23:12 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        viro@ZenIV.linux.org.uk, pinskia@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: use the gnu89 standard explicitly
Message-ID: <20141020092312.GA12047@node.dhcp.inet.fi>
References: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413772855-8613-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 10:40:55PM -0400, Sasha Levin wrote:
> gcc5 changes the default standard to c11, which makes kernel
> build unhappy.
> 
> Explicitly define the kernel standard to be gnu89 which should
> keep everything working exactly like it was before gcc5.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
> 
> Changes from v1:
>   - I've accidently placed the statement in a CONFIG_READABLE_ASM.
> It shouldn't be there.
> 
>  Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index dd7e1cb..eb0c026 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -625,6 +625,7 @@ all: vmlinux
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
>  KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
> +KBUILD_CFLAGS	+= $(call cc-option,-std=gnu89,)

I'm pretty sure all gcc versions you can build kernel with supports
-std=gnu89. cc-option is redunrant.

We also need to adjust HOSTCFLAGS otherwise allmodconfig fails for me.

Singed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com.

diff --git a/Makefile b/Makefile
index 05d67af376c5..27570984f28e 100644
--- a/Makefile
+++ b/Makefile
@@ -297,7 +297,7 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 
 HOSTCC       = gcc
 HOSTCXX      = g++
-HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
+HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu89
 HOSTCXXFLAGS = -O2
 
 ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
@@ -401,7 +401,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                   -fno-strict-aliasing -fno-common \
                   -Werror-implicit-function-declaration \
-                  -Wno-format-security
+                  -Wno-format-security \
+                  -std=gnu89
 
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
-- 
 Kirill A. Shutemov

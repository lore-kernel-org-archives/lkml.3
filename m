Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbbAZRbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:31:17 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43384 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbAZRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:31:14 -0500
Date: Mon, 26 Jan 2015 17:31:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/5] syscalls: Declare sys_*stat64 prototypes if
 __ARCH_WANT_(COMPAT_)STAT64
Message-ID: <20150126173103.GD14048@e104818-lin.cambridge.arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
 <1420819048-3515-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420819048-3515-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:57:25PM +0000, Catalin Marinas wrote:
> Currently, the sys_stat64, sys_fstat64 and sys_lstat64 prototpyes are
> only declared if BITS_PER_LONG == 32. Following commit 0753f70f07fb
> (fs: Build sys_stat64() and friends if __ARCH_WANT_COMPAT_STAT64), the
> implementation of these functions is allowed on 64-bit systems for
> compat support. The patch changes the condition on the prototype
> declaration from BITS_PER_LONG == 32 to defined(__ARCH_WANT_STAT64) ||
> defined(__ARCH_WANT_COMPAT_STAT64).
> 
> In addition, it moves the sys_fstatat64 prototype under the same #if
> block
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>

Andrew,

Are you ok with this patch (and the previous one)? They trivial changes
to add or enable some prototypes. If you are ok with them, I'd like to
push them with the rest of the series via the arm64 tree.

Thanks (patch below for reference).

Catalin

>  include/linux/syscalls.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 85893d744901..76d1e38aabe1 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -410,12 +410,16 @@ asmlinkage long sys_newlstat(const char __user *filename,
>  				struct stat __user *statbuf);
>  asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf);
>  asmlinkage long sys_ustat(unsigned dev, struct ustat __user *ubuf);
> -#if BITS_PER_LONG == 32
> +#if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
>  asmlinkage long sys_stat64(const char __user *filename,
>  				struct stat64 __user *statbuf);
>  asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
>  asmlinkage long sys_lstat64(const char __user *filename,
>  				struct stat64 __user *statbuf);
> +asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
> +			       struct stat64 __user *statbuf, int flag);
> +#endif
> +#if BITS_PER_LONG == 32
>  asmlinkage long sys_truncate64(const char __user *path, loff_t length);
>  asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);
>  #endif
> @@ -771,8 +775,6 @@ asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
>  			   umode_t mode);
>  asmlinkage long sys_newfstatat(int dfd, const char __user *filename,
>  			       struct stat __user *statbuf, int flag);
> -asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
> -			       struct stat64 __user *statbuf, int flag);
>  asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
>  			       int bufsiz);
>  asmlinkage long sys_utimensat(int dfd, const char __user *filename,

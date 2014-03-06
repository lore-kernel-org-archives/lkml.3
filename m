Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaCFM2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:28:51 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:43798 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCFM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:28:49 -0500
Message-ID: <53186A02.6010203@gmail.com>
Date: Thu, 06 Mar 2014 07:28:50 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: jon@ringle.org, linux-kernel@vger.kernel.org
CC: Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] Add option to build with -O3
References: <1394004995-27963-1-git-send-email-jon@ringle.org>
In-Reply-To: <1394004995-27963-1-git-send-email-jon@ringle.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-05 02:36, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  Makefile     |  2 ++
>  init/Kconfig | 19 ++++++++++++++++---
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 78209ee..e7f0b3c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -581,6 +581,8 @@ all: vmlinux
>  
>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
>  KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
> +else ifdef CONFIG_CC_OPTIMIZE_FOR_SPEED
> +KBUILD_CFLAGS   += -O3
>  else
>  KBUILD_CFLAGS	+= -O2
>  endif
> diff --git a/init/Kconfig b/init/Kconfig
> index 009a797..17d4c62 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1233,13 +1233,26 @@ source "usr/Kconfig"
>  
>  endif
>  
> +choice
> +    prompt "Optimize"
> +
> +config CC_OPTIMIZE_NORMAL
> +    bool "Optimize Normal (-O2)"
> +    help
> +      Enabling this option will pass "-O2" to gcc
>  config CC_OPTIMIZE_FOR_SIZE
> -	bool "Optimize for size"
> +	bool "Optimize for size (-Os)"
>  	help
> -	  Enabling this option will pass "-Os" instead of "-O2" to gcc
> +	  Enabling this option will pass "-Os" to gcc
>  	  resulting in a smaller kernel.
>  
> -	  If unsure, say N.
> +config CC_OPTIMIZE_FOR_SPEED
> +    bool "Optimze for speed (-O3)"
> +    help
> +      Enabling this option will pass "-O3" to gcc
> +      resulting in a larger kernel (but possibly faster)
> +
> +endchoice
>  
>  config SYSCTL
>  	bool
> 
I would suggest putting a warning in the Kconfig text that this might
make things break in new and unusual ways (and possibly making it depend
on EXPERT).  All of the cases of -O3 breaking userspace software that I
have seen involve really edgy and complex (and often potentially
ambiguous) code, and while the core kernel doesn't have much of this,
there are a number drivers that do (The Synopsis DWC USB OTG driver
immediately comes to mind, as well as a number of drivers from staging).

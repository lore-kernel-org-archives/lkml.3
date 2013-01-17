Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab3AQQcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:32:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46335 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3AQQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:32:17 -0500
Date: Thu, 17 Jan 2013 08:26:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <james.l.morris@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 84/86] lib: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130117162650.GA3159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
 <1358391258-1771-85-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358391258-1771-85-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011716-2876-0000-0000-00000431BF2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:54:16PM -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: "Paul E. McKenney" <paul.mckenney@linaro.org>
> CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> CC: James Morris <james.l.morris@oracle.com>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: Akinobu Mita <akinobu.mita@gmail.com>
> CC: Ingo Molnar <mingo@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  lib/Kconfig       |    2 +-
>  lib/Kconfig.debug |    2 +-
>  lib/Kconfig.kgdb  |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 75cdb77..3958dc4 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -322,7 +322,7 @@ config CPUMASK_OFFSTACK
> 
>  config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
>         bool "Disable obsolete cpumask functions" if DEBUG_PER_CPU_MAPS
> -       depends on EXPERIMENTAL && BROKEN
> +       depends on BROKEN
> 
>  config CPU_RMAP
>  	bool
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 67604e5..849ecae 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -455,7 +455,7 @@ config HAVE_DEBUG_KMEMLEAK
> 
>  config DEBUG_KMEMLEAK
>  	bool "Kernel memory leak detector"
> -	depends on DEBUG_KERNEL && EXPERIMENTAL && HAVE_DEBUG_KMEMLEAK
> +	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
>  	select DEBUG_FS
>  	select STACKTRACE if STACKTRACE_SUPPORT
>  	select KALLSYMS
> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> index 43cb93f..77439eb 100644
> --- a/lib/Kconfig.kgdb
> +++ b/lib/Kconfig.kgdb
> @@ -5,7 +5,7 @@ config HAVE_ARCH_KGDB
>  menuconfig KGDB
>  	bool "KGDB: kernel debugger"
>  	depends on HAVE_ARCH_KGDB
> -	depends on DEBUG_KERNEL && EXPERIMENTAL
> +	depends on DEBUG_KERNEL
>  	help
>  	  If you say Y here, it will be possible to remotely debug the
>  	  kernel using gdb.  It is recommended but not required, that
> -- 
> 1.7.9.5
> 


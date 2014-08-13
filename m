Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHMP5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:57:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59108 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaHMP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:57:17 -0400
Date: Wed, 13 Aug 2014 17:57:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lib: turn CONFIG_STACKTRACE into an actual option.
Message-ID: <20140813155712.GA24282@gmail.com>
References: <20140714192416.GA30293@redhat.com>
 <20140813150357.GA12025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813150357.GA12025@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> I was puzzled why /proc/$$/stack had disappeared, until I figured out
> I had disabled the last debug option that did a 'select STACKTRACE'.
> This patch makes the option show up at config time, so it can be
> enabled without enabling any of the more heavyweight debug options.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7a638aa3545b..96c64beac12a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1008,8 +1008,13 @@ config TRACE_IRQFLAGS
>  	  either tracing or lock debugging.
>  
>  config STACKTRACE
> -	bool
> +	bool "Stack backtrace support"
>  	depends on STACKTRACE_SUPPORT
> +	help
> +	  This option causes the kernel to create a /proc/pid/stack for
> +	  every process, showing its current stack trace.
> +	  It is also used by various kernel debugging features that require
> +	  stack trace generation.
>  
>  config DEBUG_KOBJECT
>  	bool "kobject debugging"

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

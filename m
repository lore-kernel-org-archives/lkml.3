Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3ECLxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:53:38 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34943 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3ECLxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:53:37 -0400
Date: Fri, 3 May 2013 13:53:32 +0200
From: Robert Richter <rric@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        oprofile-list@lists.sf.net, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH, RFC 14/22] oprofile: always enable IRQ_WORK
Message-ID: <20130503115332.GT8356@rric.localhost>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-15-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367507786-505303-15-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.05.13 17:16:18, Arnd Bergmann wrote:
> oprofile fails to build if CONFIG_IRQ_WORK is not already enabled,
> because of the dependency on the RING_BUFFER code that now uses
> the irq work library.
> 
> kernel/built-in.o: In function `ring_buffer_unlock_commit':
> :(.text+0x5b8f0): undefined reference to `irq_work_queue'
> kernel/built-in.o: In function `ring_buffer_write':
> :(.text+0x5bd10): undefined reference to `irq_work_queue'

Shouldn't this be fixed in the ring_buffer implementation?

I also do not see, where this comes from. I was successfully compiling
a kernel with OPROFILE and RING_BUFFER enabled but IRQ_WORK disabled.
Do you have that config still available?

Thanks,

-Robert

> 
> Cc: Robert Richter <rric@kernel.org>
> Cc: oprofile-list@lists.sf.net
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index a6b1056..434a8dc 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -8,6 +8,7 @@ config OPROFILE
>  	depends on HAVE_OPROFILE
>  	select RING_BUFFER
>  	select RING_BUFFER_ALLOW_SWAP
> +	select IRQ_WORK
>  	help
>  	  OProfile is a profiling system capable of profiling the
>  	  whole system, include the kernel, kernel modules, libraries,
> -- 
> 1.8.1.2
> 

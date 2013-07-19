Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab3GSQRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:17:15 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53091 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3GSQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:17:13 -0400
Date: Fri, 19 Jul 2013 18:17:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/3] ARM: Kconfig: allow virt CPU accounting
Message-ID: <20130719161708.GB21752@somewhere>
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
 <1372876601-23881-4-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372876601-23881-4-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:36:41AM -0700, Kevin Hilman wrote:
> With the 64-bit requirement removed from virt CPU accounting,
> allow ARM platforms to enable it.
> 
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  arch/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 136f263..7850612 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -61,6 +61,7 @@ config ARM
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
>  	select HAVE_CONTEXT_TRACKING
> +	select HAVE_VIRT_CPU_ACCOUNTING

I think you got confused here. HAVE_VIRT_CPU_ACCOUNTING is the arch capability
for VIRT_CPU_ACCOUNTING_NATIVE, not for VIRT_CPU_ACCOUNTING_GEN that only requires
support for context tracking.

That's my bad, all those names start to be confusing now.
The VIRT based Kconfig naming is a bit weird, that doesn't really reflect what the feature
is doing. "Virtual cputime accounting" just doesn't give any clue, except perhaps suggesting
the stuff deals with virtualization while it actually has nothing to do with.
I don't even know what virtual refers to here.

Same goes for vtime based APIs. In fact I just based my work on the legacy that was
there and expanded further the non-sense ;-)

I'll need to do a big renaming one day.

But to begin with I should rename s/HAVE_VIRT_CPU_ACCOUNTING/HAVE_VIRT_CPU_ACCOUNTING_NATIVE.



>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
>  	  licensed by ARM Ltd and targeted at embedded applications and
> -- 
> 1.8.3
> 

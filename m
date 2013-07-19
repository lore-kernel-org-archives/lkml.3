Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680Ab3GSQ3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:29:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47902 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3GSQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:08 -0400
Date: Fri, 19 Jul 2013 18:29:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] nohz: Kconfig: remove redundant 64-bit dependency
Message-ID: <20130719162903.GC21752@somewhere>
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
 <1372876601-23881-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372876601-23881-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:36:39AM -0700, Kevin Hilman wrote:
> The current 64-bit dependency is on VIRT_CPU_ACCOUNTING_GEN, which already
> has its own dependency on 64-bit.  Remove it from NO_HZ_FULL.

It's not exactly redundant. It's a necessary dependency inheritance.
When we select NO_HZ_FULL, TICK_CPU_ACCOUNTING and VIRT_CPU_ACCOUNTING_NATIVE
disappear such that only VIRT_CPU_ACCOUNTING_GEN can be selected. But if we
don't have CONFIG_64bits, then VIRT_CPU_ACCOUNTING_GEN is not possible either.
So we end up with nothing for the accounting (or whatever random reaction
from Kconfig against that situation) and that's a bug. So we need to inherit the
64 bits dependency on NO_HZ_FULL to prevent that.

We can remove this dependency from NO_HZ_FULL, but only once we remove it
from VIRT_CPU_ACCOUNTING_GEN, not the other way around otherwise this
breaks bisection.

> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/time/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 70f27e8..b78760f 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -99,8 +99,6 @@ config NO_HZ_FULL
>  	depends on SMP
>  	# RCU_USER_QS dependency
>  	depends on HAVE_CONTEXT_TRACKING
> -	# VIRT_CPU_ACCOUNTING_GEN dependency
> -	depends on 64BIT
>  	select NO_HZ_COMMON
>  	select RCU_USER_QS
>  	select RCU_NOCB_CPU
> -- 
> 1.8.3
> 

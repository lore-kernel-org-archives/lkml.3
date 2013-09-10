Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3IJWD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:03:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:55381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3IJWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:03:55 -0400
Message-ID: <1378850610.4121.29.camel@pasglop>
Subject: Re: [PATCH] powerpc: Export cpu_to_chip_id() to fix build error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:03:30 +1000
In-Reply-To: <1378777076-4699-1-git-send-email-linux@roeck-us.net>
References: <1378777076-4699-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 18:37 -0700, Guenter Roeck wrote:
> powerpc allmodconfig build fails with:
> 
> ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
> 
> The problem was introduced with commit 15863ff3b (powerpc: Make chip-id
> information available to userspace).

Thanks, I'll send that to Linus asap.

Ben.

> Export the missing symbol.
> 
> Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
> Cc: Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/powerpc/kernel/smp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 442d8e2..8e59abc 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -611,6 +611,7 @@ int cpu_to_chip_id(int cpu)
>  	of_node_put(np);
>  	return of_get_ibm_chip_id(np);
>  }
> +EXPORT_SYMBOL(cpu_to_chip_id);
>  
>  /* Helper routines for cpu to core mapping */
>  int cpu_core_index_of_thread(int cpu)



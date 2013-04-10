Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3DJE5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:57:05 -0400
Received: from ozlabs.org ([203.10.76.45]:39989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3DJE5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:57:03 -0400
Date: Wed, 10 Apr 2013 14:56:59 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, paulus@samba.org,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH v2 6/6] powerpc: Use generic code for exception
 handling
Message-ID: <20130410045659.GB15929@concordia>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
 <1364551221-23177-7-git-send-email-zhong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364551221-23177-7-git-send-email-zhong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 06:00:21PM +0800, Li Zhong wrote:
> After the exception handling moved to generic code, and some changes in
...
> diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> index 360fba8..eeab30f 100644
> --- a/arch/powerpc/mm/hash_utils_64.c
> +++ b/arch/powerpc/mm/hash_utils_64.c
> @@ -33,6 +33,7 @@
>  #include <linux/init.h>
>  #include <linux/signal.h>
>  #include <linux/memblock.h>
> +#include <linux/context_tracking.h>
>  
>  #include <asm/processor.h>
>  #include <asm/pgtable.h>
> @@ -56,7 +57,6 @@
>  #include <asm/fadump.h>
>  #include <asm/firmware.h>
>  #include <asm/tm.h>
> -#include <asm/context_tracking.h>
>  
>  #ifdef DEBUG
>  #define DBG(fmt...) udbg_printf(fmt)
> @@ -919,13 +919,17 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
>  	const struct cpumask *tmp;
>  	int rc, user_region = 0, local = 0;
>  	int psize, ssize;
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
>  
>  	DBG_LOW("hash_page(ea=%016lx, access=%lx, trap=%lx\n",
>  		ea, access, trap);
>  
>  	if ((ea & ~REGION_MASK) >= PGTABLE_RANGE) {
>  		DBG_LOW(" out of pgtable range !\n");
> - 		return 1;
> +		rc = 1;
> +		goto exit;
>  	}
>  
>  	/* Get region & vsid */

This no longer applies on mainline, please send an updated version.

cheers

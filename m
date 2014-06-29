Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaF2CYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 22:24:08 -0400
Received: from ozlabs.org ([103.22.144.67]:46862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaF2CYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 22:24:05 -0400
Date: Sun, 29 Jun 2014 12:24:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Message-ID: <20140629122402.0fd014d8@canb.auug.org.au>
In-Reply-To: <10901956.0EDQunEZJL@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	<10901956.0EDQunEZJL@myon.chronox.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de> wrote:
>
> @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
>  
>  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
>  		pr_info("DRBG: Cannot register all DRBG types"
> -			"(slots needed: %lu, slots available: %lu)\n",
> -			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
> +			"(slots needed: %u, slots available: %u)\n",
> +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> +			(unsigned int)ARRAY_SIZE(drbg_algs));

Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
need no casts, but need to us %zu in the format string.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

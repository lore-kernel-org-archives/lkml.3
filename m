Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaG1Jtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:49:35 -0400
Received: from verein.lst.de ([213.95.11.211]:42052 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaG1Jtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:49:33 -0400
Date: Mon, 28 Jul 2014 11:49:29 +0200
From: Torsten Duwe <duwe@lst.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] hwrng: Pass entropy to add_hwgenerator_randomness() in
	bits, not bytes
Message-ID: <20140728094929.GJ972@lst.de>
References: <1406326758-4516-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406326758-4516-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:19:18PM -0700, Stephen Boyd wrote:
> rng_get_data() returns the number of bytes read from the hardware.
> The entropy argument to add_hwgenerator_randomness() is passed
> directly to credit_entropy_bits() so we should be passing the
> number of bits, not bytes here.

Absolutely correct.

Acked-by: Torsten Duwe <duwe@suse.de>

> Fixes: be4000bc464 "hwrng: create filler thread"
> Cc: Torsten Duwe <duwe@suse.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/char/hw_random/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index dc80cdab733d..6e02ec103cc7 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -362,7 +362,7 @@ static int hwrng_fillfn(void *unused)
>  			continue;
>  		}
>  		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
> -					   (rc*current_quality)>>10);
> +					   rc * current_quality * 8 >> 10);
>  	}
>  	hwrng_fill = NULL;
>  	return 0;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

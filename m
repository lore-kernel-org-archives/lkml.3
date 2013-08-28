Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3H1Spl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:45:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45729 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753533Ab3H1Spk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:45:40 -0400
Message-ID: <1377715539.1928.45.camel@joe-AO722>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
From: Joe Perches <joe@perches.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org
Date: Wed, 28 Aug 2013 11:45:39 -0700
In-Reply-To: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 20:29 +0200, Mischa Jonker wrote:
> Make sure that usecs is casted to long long, to ensure that the
> (usecs * 4295 * HZ) multiplication is 64 bit.
> 
> Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
> multiplication, with the result casted to 64 bit. This led to some bits
> falling off.
> 
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> ---
>  arch/arc/include/asm/delay.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
> index 442ce5d..8d35fe1 100644
> --- a/arch/arc/include/asm/delay.h
> +++ b/arch/arc/include/asm/delay.h
> @@ -56,8 +56,8 @@ static inline void __udelay(unsigned long usecs)
>  	/* (long long) cast ensures 64 bit MPY - real or emulated
>  	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
>  	 */
> -	loops = ((long long)(usecs * 4295 * HZ) *
> -		 (long long)(loops_per_jiffy)) >> 32;
> +	loops = (((long long) usecs) * 4295 * HZ *
> +		  (long long) loops_per_jiffy) >> 32;

Shouldn't this be unsigned long long or u64?

Why is it >> 32 again?

The comment above it doesn't seem to match the code.



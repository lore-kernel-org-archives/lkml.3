Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaEHNav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:30:51 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:60498 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaEHNat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:30:49 -0400
Date: Thu, 8 May 2014 21:30:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milos Vyletel <milos.vyletel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
        linux-coverity@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Message-ID: <20140508133025.GB12700@gondor.apana.org.au>
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 03:17:54PM -0400, Milos Vyletel wrote:
> Coverity detected possible use of uninitialized pointer when printing info
> message during module load. While this is higly unlikely to cause any troubles
> simple change in sha1_ssse3_mod_init to make it look like sha256/512 init
> function will fix this.
> 
> 260
>    	6. Condition sha1_transform_asm, taking true branch
> 261        if (sha1_transform_asm) {
> 
> CID 1195603 (#1 of 1): Uninitialized pointer read (UNINIT)
> 7. uninit_use_in_call: Using uninitialized value algo_name when calling printk.
> 262                pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
> 263                return crypto_register_shash(&alg);
> 264        }
> 
> Reported-by: <scan-admin@coverity.com>
> Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>

Unless I'm missing something there is no way this code can use
the variable without initialising it.

So this is a false positive and I'm not applying this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

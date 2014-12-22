Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaLVL1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:27:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59750 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaLVL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:27:37 -0500
Date: Mon, 22 Dec 2014 22:27:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 5/8] crypto: AF_ALG: add user space interface for RNG
Message-ID: <20141222112730.GB19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3380968.kTQNpvjKFa@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3380968.kTQNpvjKFa@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 11:23:48PM +0100, Stephan Mueller wrote:
> Allow user space to seed / reset the RNG via a setsockopt.
> 
> This patch reuses alg_setkey to copy data into the kernel. The
> alg_setkey is now used for two mechanisms: setkey and seeding.
> The function is extended by the providing the function pointer
> to the function handling the copied data.
> 
> As the alg_setkey is now usable for more than just setkey, it is renamed
> to alg_setop.

Just call it setkey, there is no harm in treating the seed as a key
is there?

In fact we should have done this from the very start.
crypto_rng_reset should be renamed crypto_rng_setkey.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

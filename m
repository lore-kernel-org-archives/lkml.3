Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaLVLXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:23:53 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:45055 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaLVLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:23:52 -0500
Date: Mon, 22 Dec 2014 22:23:41 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Message-ID: <20141222112341.GA19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3151022.sz5v21Vqeg@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3151022.sz5v21Vqeg@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 11:22:30PM +0100, Stephan Mueller wrote:
>
> +static inline bool aead_sufficient_data(struct aead_ctx *ctx)
> +{
> +	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
> +
> +	return (ctx->used >= (ctx->aead_assoclen + ctx->enc ? : as ));

Is this supposed to be

	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ?: as)));

> +static int aead_recvmsg(struct kiocb *unused, struct socket *sock,
> +			    struct msghdr *msg, size_t ignored, int flags)
> +{

...

> +	err = -ENOMEM;
> +	if (!aead_sufficient_data(ctx))
> +		goto unlock;

You should just block if there is insufficient input.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

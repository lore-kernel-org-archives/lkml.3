Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbbAKQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:16:59 -0500
Received: from mail.eperm.de ([89.247.134.16]:59441 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbbAKQQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:16:56 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v9 1/2] crypto: AF_ALG: add AEAD support
Date: Sun, 11 Jan 2015 17:16:49 +0100
Message-ID: <2521789.meJGi556Ec@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1518783.PStT3Q01B6@tachyon.chronox.de>
References: <41794881.9gBey4al6X@tachyon.chronox.de> <1518783.PStT3Q01B6@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. Januar 2015, 04:45:53 schrieb Stephan Mueller:

Hi Herbert,

> +static int aead_accept_parent(void *private, struct sock *sk)
> +{
> +	struct aead_ctx *ctx;
> +	struct alg_sock *ask = alg_sk(sk);
> +	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
> +	unsigned int ivlen = crypto_aead_ivsize(private);
> +
> +	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +	memset(ctx, 0, len);
> +
> +	ctx->iv = sock_kmalloc(sk, ivlen, GFP_KERNEL);
> +	if (!ctx->iv) {
> +		sock_kfree_s(sk, ctx, len);
> +		return -ENOMEM;
> +	}
> +	memset(ctx->iv, 0, ivlen);
> +
> +	ctx->len = len;
> +	ctx->used = 0;
> +	ctx->more = 0;
> +	ctx->merge = 0;
> +	ctx->enc = 0;
> +	ctx->tsgl.cur = 0;

ctx->trunc = 0;

is missing here.

I would wait with a new patch once you had the chance to review the updates 
and provide comments.

Thanks
-- 
Ciao
Stephan

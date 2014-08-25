Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaHYHEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:04:30 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54455 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaHYHE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <1408912715-9719-1-git-send-email-colin.king@canonical.com>
References: <1408912715-9719-1-git-send-email-colin.king@canonical.com>
Date: Mon, 25 Aug 2014 09:04:27 +0200
Message-ID: <CAKv+Gu8GjSi4r2hCbnhQ2rDFJaO_PH3=JmfKKTsELDqCuf_cLw@mail.gmail.com>
Subject: Re: [PATCH] arm64/crypto: remove redundant update of data
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Colin King <colin.king@canonical.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 August 2014 22:38, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Originally found by cppcheck:
>
> [arch/arm64/crypto/sha2-ce-glue.c:153]: (warning) Assignment of
>   function parameter has no effect outside the function. Did you
>   forget dereferencing it?
>
> Updating data by blocks * SHA256_BLOCK_SIZE at the end of
> ha2_finup is redundant code and can be removed.
>

^^^ typo here

> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>  arch/arm64/crypto/sha2-ce-glue.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index c294e67..ae67e88 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -150,7 +150,6 @@ static void sha2_finup(struct shash_desc *desc, const u8 *data,
>         kernel_neon_begin_partial(28);
>         sha2_ce_transform(blocks, data, sctx->state, NULL, len);
>         kernel_neon_end();
> -       data += blocks * SHA256_BLOCK_SIZE;
>  }
>
>  static int sha224_finup(struct shash_desc *desc, const u8 *data,
> --
> 2.1.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

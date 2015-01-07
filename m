Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbbAGIY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:24:27 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:42233 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbAGIYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:24:25 -0500
Date: Wed, 7 Jan 2015 09:24:14 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@sunrus.com.cn>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, schwidefsky@de.ibm.com,
        linux390@de.ibm.com, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: crypto: aes_s390: Remove 'const' to avoid compiler
 warnings
Message-ID: <20150107082414.GA4365@osiris>
References: <54A56002.3000301@sunrus.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A56002.3000301@sunrus.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010708-0021-0000-0000-000002720C1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 10:56:02PM +0800, Chen Gang wrote:
> In aes_encrypt() and aes_decrypt(), need let 'sctx->key' be modified,
> so remove 'const' for it. The related warnings:
...
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/s390/crypto/aes_s390.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index 1f272b2..5566ce8 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -134,7 +134,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> 
>  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
> -	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> +	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> 
>  	if (unlikely(need_fallback(sctx->key_len))) {
>  		crypto_cipher_encrypt_one(sctx->fallback.cip, out, in);
> @@ -159,7 +159,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> 
>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
> -	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> +	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> 
>  	if (unlikely(need_fallback(sctx->key_len))) {
>  		crypto_cipher_decrypt_one(sctx->fallback.cip, out, in);

Applied, thanks.


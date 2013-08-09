Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278Ab3HIGZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:25:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:36850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030199Ab3HIGZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:25:23 -0400
Message-ID: <1376029504.32100.16.camel@pasglop>
Subject: Re: [PATCH v2] drivers/crypto/nx: saves chaining value from
 co-processor
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, herbert@gondor.hengli.com.au,
        mhcerri@linux.vnet.ibm.com
Date: Fri, 09 Aug 2013 16:25:04 +1000
In-Reply-To: <1375917350.16050.14.camel@what-is-leg>
References: <1375917350.16050.14.camel@what-is-leg>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 18:15 -0500, Fionnuala Gunter wrote:
> This patch fixes a bug that is triggered when cts(cbc(aes)) is used with
> nx-crypto driver on input larger than 32 bytes.
> 
> The chaining value from co-processor was not being saved. This value is
> needed because it is used as the IV by cts(cbc(aes)).
> 
> Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>

Herbert, I assume you will handle this along with all the other NX fixes
and I can safely take them out of linuxppc patchwork ?

Cheers,
Ben.

> ---
> v2. changed signed-off-by to reviewed-by and added more details to
> description
> 
> This bug appeared in the original submission (v3.5)
> ---
>  drivers/crypto/nx/nx-aes-cbc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/nx/nx-aes-cbc.c
> b/drivers/crypto/nx/nx-aes-cbc.c
> index 35d483f..a2f99a9 100644
> --- a/drivers/crypto/nx/nx-aes-cbc.c
> +++ b/drivers/crypto/nx/nx-aes-cbc.c
> @@ -95,6 +95,7 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc
> *desc,
>         if (rc)
>                 goto out;
> 
> +       memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
>         atomic_inc(&(nx_ctx->stats->aes_ops));
>         atomic64_add(csbcpb->csb.processed_byte_count,
>                      &(nx_ctx->stats->aes_bytes));



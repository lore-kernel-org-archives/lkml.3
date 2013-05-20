Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3ETLr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:47:26 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43724 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755786Ab3ETLrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:47:22 -0400
Date: Mon, 20 May 2013 19:47:07 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Xiong Zhou <jencce.kernel@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Message-ID: <20130520114707.GA1187@gondor.apana.org.au>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
 <5193CCEC.7070909@infradead.org>
 <alpine.DEB.2.02.1305161152530.31865@M2420>
 <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
 <1368723552.27102.286.camel@schen9-DESK>
 <1368727412.27102.289.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368727412.27102.289.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:03:32AM -0700, Tim Chen wrote:
>
> Need to also add select CRYPTO for CRC_T10DIF.  Updated fix below:
> 
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index d1ca631..015df24 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -379,6 +379,7 @@ config CRYPTO_CRC32_PCLMUL
>  config CRYPTO_CRCT10DIF
>  	tristate "CRCT10DIF algorithm"
>  	select CRYPTO_HASH
> +	depends on CRC_T10DIF
>  	help
>  	  CRC T10 Data Integrity Field computation is being cast as
>  	  a crypto transform.  This allows for faster crc t10 diff
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 0cee056..6407793 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -63,7 +63,8 @@ config CRC16
>  
>  config CRC_T10DIF
>  	tristate "CRC calculation for the T10 Data Integrity Field"
> -	select CRYPTO_CRCT10DIF
> +	select CRYPTO
> +	select CRYPTO_HASH
>  	help
>  	  This option is only needed if a module that's not in the
>  	  kernel tree needs to calculate CRC checks for use with the

Nope this is still broken.  We need to move the actual crct10dif
code into crypto/.  I'll fix up the patch in the tree.

Also I'm going to get rid of crc_t10dif_update_lib function.  If you
still want to maintain the ordering you should do so using the
*_init constructs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

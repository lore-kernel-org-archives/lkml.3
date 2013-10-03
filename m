Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3JCCyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:54:05 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:65371 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3JCCyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131002235615.GA7419@pd.tnic>
References: <CA+r1ZhgsXTZ_x-jzS2OpjryhCExrG0B6nB_Ph4gb9_BJL4zeCA@mail.gmail.com>
	<20131002235615.GA7419@pd.tnic>
Date: Wed, 2 Oct 2013 19:54:01 -0700
Message-ID: <CA+r1ZhhEL22-8N3McHaHZ9hmsC84mwkgz39O8t9sC967FjM_4g@mail.gmail.com>
Subject: Re: randconfig build error with next-20131002, in crypto
From: Jim Davis <jim.epost@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 4:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Oct 02, 2013 at 03:19:51PM -0700, Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>>   LD      init/built-in.o
>> crypto/built-in.o: In function `RSA_verify_signature':
>> rsa.c:(.text+0x2dc5e): undefined reference to `mpi_get_nbits'
>> rsa.c:(.text+0x2dc68): undefined reference to `mpi_get_nbits'
>> rsa.c:(.text+0x2dc89): undefined reference to `mpi_free'
>> rsa.c:(.text+0x2dca4): undefined reference to `mpi_cmp_ui'
>> rsa.c:(.text+0x2dcb7): undefined reference to `mpi_cmp'
>> rsa.c:(.text+0x2dcc6): undefined reference to `mpi_alloc'
>> rsa.c:(.text+0x2dce7): undefined reference to `mpi_powm'
>> rsa.c:(.text+0x2dcff): undefined reference to `mpi_get_nbits'
>> rsa.c:(.text+0x2dd1c): undefined reference to `mpi_get_buffer'
>> rsa.c:(.text+0x2de07): undefined reference to `mpi_free'
>> make: *** [vmlinux] Error 1
>
> Looks like someone has forgotten this completely unused MPILIB_EXTRA
> thing in there.
>
> Does this totally untested but obvious patch help?
>
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 3 Oct 2013 01:51:15 +0200
> Subject: [PATCH] crypto: Correct RSA MPI dependency
>
> 9e235dcaf4f6 ("Revert "crypto: GnuPG based MPI lib - additional sources
> (part 4)") removed the MPI lib extra stuff but left RSA selecting it
> while it should select CONFIG_MPILIB instead. Fix it.
>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  crypto/asymmetric_keys/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 6d2c2ea12559..755f6174585a 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -21,7 +21,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  config PUBLIC_KEY_ALGO_RSA
>         tristate "RSA public-key algorithm"
>         depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> -       select MPILIB_EXTRA
> +       select MPILIB
>         help
>           This option enables support for the RSA algorithm (PKCS#1, RFC3447).
>
> --
> 1.8.4
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

Yes, with the change that configuration file didn't generate a build
error.  Tested-by: jim.epost@gmail.com (if it isn't overkill for for
an obvious patch!).  Thanks.

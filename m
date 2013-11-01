Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3KASV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:21:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56807 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KASV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:21:57 -0400
Message-ID: <5273F142.3090608@infradead.org>
Date: Fri, 01 Nov 2013 11:21:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 31 (crypto, rsa, mpi)
References: <5272C55E.7050004@infradead.org> <20131031210027.cb3604b9589e0b7a1599dbd2@canb.auug.org.au> <5808.1383318971@warthog.procyon.org.uk>
In-Reply-To: <5808.1383318971@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 08:16, David Howells wrote:
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> crypto/built-in.o: In function `RSA_verify_signature':
>> rsa.c:(.text+0x1d347): undefined reference to `mpi_get_nbits'
>> rsa.c:(.text+0x1d354): undefined reference to `mpi_get_nbits'
>> ...
> 
> Does the attached patch fix it for you?

Yes, thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> 
> David
> ---
> KEYS: The RSA public key algorithm needs to select MPILIB
> 
> The RSA public key algorithm needs to select MPILIB directly in Kconfig as the
> 'select' directive is not recursive and is thus MPILIB is not enabled by
> selecting MPILIB_EXTRA.
> 
> Without this, the following errors can occur:
> 
> 	crypto/built-in.o: In function `RSA_verify_signature':
> 	rsa.c:(.text+0x1d347): undefined reference to `mpi_get_nbits'
> 	rsa.c:(.text+0x1d354): undefined reference to `mpi_get_nbits'
> 	rsa.c:(.text+0x1d36e): undefined reference to `mpi_cmp_ui'
> 	rsa.c:(.text+0x1d382): undefined reference to `mpi_cmp'
> 	rsa.c:(.text+0x1d391): undefined reference to `mpi_alloc'
> 	rsa.c:(.text+0x1d3b0): undefined reference to `mpi_powm'
> 	rsa.c:(.text+0x1d3c3): undefined reference to `mpi_free'
> 	rsa.c:(.text+0x1d3d8): undefined reference to `mpi_get_buffer'
> 	rsa.c:(.text+0x1d4d4): undefined reference to `mpi_free'
> 	rsa.c:(.text+0x1d503): undefined reference to `mpi_get_nbits'
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 82e7d6b0c276..03a6eb95ab50 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -23,6 +23,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  config PUBLIC_KEY_ALGO_RSA
>  	tristate "RSA public-key algorithm"
>  	select MPILIB_EXTRA
> +	select MPILIB
>  	help
>  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
>  
> 


-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaKROGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:06:42 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39712 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaKROGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:06:40 -0500
Date: Tue, 18 Nov 2014 22:06:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for
 AEAD
Message-ID: <20141118140631.GA12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <11608519.pS4L9VjM2n@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11608519.pS4L9VjM2n@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 03:23:50AM +0100, Stephan Mueller wrote:
> AEAD requires the following data in addition to normal symmetric
> ciphers:
> 
> 	* Associated authentication data of arbitrary length
> 
> 	* Authentication tag for decryption
> 
> 	* Length of authentication tag for encryption
> 
> The authentication tag data is communicated as part of the actual
> ciphertext as mandated by the kernel crypto API. Therefore we only need
> to provide a user space interface for the associated authentication data
> as well as for the authentication tag length.
> 
> This patch adds both as a setsockopt interface that is identical to the
> AF_ALG interface for setting an IV and for selecting the cipher
> operation type (encrypt or decrypt).
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

I don't like the fact that we're putting arbitrary limits on
the AD, as well as the fact that the way you're doing it the
AD has to be copied.

How about simply saying that the first X bytes of the input
shall be the AD?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

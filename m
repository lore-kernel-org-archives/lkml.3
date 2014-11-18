Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaKROIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:08:34 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38039 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaKROI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:08:29 -0500
Date: Tue, 18 Nov 2014 22:08:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Message-ID: <20141118140822.GB12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2688209.3bGZus2TD9@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 03:24:25AM +0100, Stephan Mueller wrote:
> The AF_ALG interface allows normal cipher (hash, encrypt, decrypt).
> However, it does not allow user space to obtain the following generic
> information about the currently active cipher:
> 
> 	* block size of the cipher
> 
> 	* IV size of the cipher
> 
> 	* for AEAD, the maximum authentication tag size
> 
> The patch adds a getsockopt interface for the symmetric ciphers to
> answer such information requests from user space.
> 
> The kernel crypto API function calls are used to obtain the real data.
> As all data are simple integer values, the getsockopt handler function
> uses put_user() to return the integer value to user space in the
> *optval parameter of getsockopt.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

We already have crypto_user so you should be extending that to
cover what's missing.

PS These paramters should not vary depending on the implementation,
if they do then one of the implementations must be buggy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

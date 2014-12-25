Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaLYU2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:28:55 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:54157 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaLYU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:28:41 -0500
Date: Fri, 26 Dec 2014 07:28:31 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Message-ID: <20141225202830.GA18794@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <4537021.IXSvIIgcH4@tachyon.chronox.de>
 <20141223202401.GA2474@gondor.apana.org.au>
 <2159528.zCJB0y2Cap@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2159528.zCJB0y2Cap@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 09:54:33AM +0100, Stephan Mueller wrote:
> 
> That is right, but isn't that the nature of AEAD ciphers in general? Even if 
> you are in the kernel, you need to have all scatter lists together for one 
> invocation of the AEAD cipher.

It's actually only the nature of certain algorithms like CCM which
requires the total length to start the operation.  Most AEAD
algorithms can be implemented in a way that allows piecemeal
operation.  However, as the only users of AEAD is IPsec, it's
probably not worth adding more complexity for now.

So let's proceed with your current solution.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

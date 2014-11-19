Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaKSE1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:27:14 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38621 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaKSE1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:27:13 -0500
Date: Wed, 19 Nov 2014 12:27:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for
 AEAD
Message-ID: <20141119042704.GA19258@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <11608519.pS4L9VjM2n@tachyon.chronox.de>
 <20141118140631.GA12100@gondor.apana.org.au>
 <2398701.sGeMzIcHaz@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2398701.sGeMzIcHaz@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:20:42AM +0100, Stephan Mueller wrote:
> 
> When looking deeper into skcipher_sendmsg, I see that the input data is copied 
> into the kernel using memcpy_fromiovec. The memory is allocated before the 
> memcpy call by skcipher_alloc_sgl.

Zero-copy is done through sendpage.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

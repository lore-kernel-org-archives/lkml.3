Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaLBO5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:57:53 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49542 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaLBO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:57:52 -0500
Date: Tue, 2 Dec 2014 22:57:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: algif_skcipher - initialize upon init request
Message-ID: <20141202145747.GA26301@gondor.apana.org.au>
References: <2770903.h32OWUVXRy@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2770903.h32OWUVXRy@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 10:55:26AM +0100, Stephan Mueller wrote:
> When using the algif_skcipher, the following call sequence causess a
> re-initialization:
> 
> 1. sendmsg with ALG_SET_OP and iov == NULL, iovlen == 0 (i.e
> initializing the cipher, but not sending data)
> 
> 2. sendmsg with msg->msg-controllen == 0 and iov != NULL (using the initalized
> cipher handle by sending data)
> 
> In step 2, the cipher operation type (encryption or decryption) is reset
> to always decryption, because the local variable of enc is put into
> ctx->enc as ctx->user is still zero.
> 
> The same applies when all send data is processed and ctx->used falls to
> zero followed by user space to send new data.
> 
> This patch changes the behavior to only reset the cipher operation type
> (and the IV) if such configuration request is received.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

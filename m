Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3KKB2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:28:25 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54738 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163Ab3KKB2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:28:17 -0500
Date: Mon, 11 Nov 2013 09:28:09 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Michal Nazarewicz <mpn@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH RESEND] crypto: make sure *blkcipher_walk_init properly
 initialises walk
Message-ID: <20131111012809.GA5091@gondor.apana.org.au>
References: <1384108681-23519-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384108681-23519-1-git-send-email-mpn@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 07:38:01PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> blkcipher_walk_init and ablkcipher_walk_init functions are called
> to initialise a walk structure allocated on stack, which is not
> initialised by the caller.  This means, that the fields of the
> structure contain garbage when *_init is run.
> 
> The *_init functions do not initialise all of the fields though,
> and in particular leave flags field as is.  This results in field
> containing unspecified value.
> 
> Zeroing the whole structure makes sure that all of the fields
> are initialised to the same value regardless of the values stored
> on the stack prior to the call to the *_init function.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Nack.  The field flags is used as a bit-field and all bits other
than those initialised that you see are used internally by the
walker function and will be initialised on demand.

Please do not just rely on tools such as coverity and actually
read the code when submitting patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

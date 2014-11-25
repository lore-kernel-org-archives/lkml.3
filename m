Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaKYJGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:06:13 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57646 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKYJGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:06:10 -0500
Date: Tue, 25 Nov 2014 17:06:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Message-ID: <20141125090601.GA6244@gondor.apana.org.au>
References: <3095384.PkgHxCg8eG@tauon>
 <20141124072246.GX6390@secunet.com>
 <1480327.kK94DiIqOk@tachyon.chronox.de>
 <20141125084225.GY6390@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125084225.GY6390@secunet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:42:25AM +0100, Steffen Klassert wrote:
>
> Well, I think there is a small but important difference. If a user
> requests a driver name that would match an algorithm name (i.e. cbc(aes)
> instead of cbc(aes-asm)) crypto_alg_lookup() returns the algorithm with
> the highest priority instead of telling that we don't have a driver with
> the name cbc(aes).

Does this matter though? The current user interface is only used to
query specific driver names which should never be equal to an
algorithm name.  So doing so already invokes undefined behaviour.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

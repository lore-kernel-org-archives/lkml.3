Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaL2KmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:42:01 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38050 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaL2Kl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:41:58 -0500
Date: Mon, 29 Dec 2014 21:41:49 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 3/4] crypto: AF_ALG: add random number generator
 support
Message-ID: <20141229104149.GA13699@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <2323421.LJnyPUDp59@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2323421.LJnyPUDp59@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 11:00:06PM +0100, Stephan Mueller wrote:
> This patch adds the random number generator support for AF_ALG.
> 
> A random number generator's purpose is to generate data without
> requiring the caller to provide any data. Therefore, the AF_ALG
> interface handler for RNGs only implements a callback handler for
> recvmsg.
> 
> The following parameters provided with a recvmsg are processed by the
> RNG callback handler:
> 
> 	* sock - to resolve the RNG context data structure accessing the
> 	  RNG instance private to the socket
> 
> 	* len - this parameter allows userspace callers to specify how
> 	  many random bytes the RNG shall produce and return. As the
> 	  kernel context for the RNG allocates a buffer of 128 bytes to
> 	  store random numbers before copying them to userspace, the len
> 	  parameter is checked that it is not larger than 128. If a
> 	  caller wants more random numbers, a new request for recvmsg
> 	  shall be made.
> 
> The size of 128 bytes is chose because of the following considerations:
> 
> 	* to increase the memory footprint of the kernel too much (note,
> 	  that would be 128 bytes per open socket)
> 
> 	* 128 is divisible by any typical cryptographic block size an
> 	  RNG may have
> 
> 	* A request for random numbers typically only shall supply small
> 	  amount of data like for keys or IVs that should only require
> 	  one invocation of the recvmsg function.
> 
> Note, during instantiation of the RNG, the code checks whether the RNG
> implementation requires seeding. If so, the RNG is seeded with output
> from get_random_bytes.
> 
> A fully working example using all aspects of the RNG interface is
> provided at http://www.chronox.de/libkcapi.html
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

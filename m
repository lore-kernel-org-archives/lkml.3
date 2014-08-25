Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaHYMmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:42:25 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:33001 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaHYMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:42:23 -0400
Date: Mon, 25 Aug 2014 20:42:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/8] DRBG: efficiency patches
Message-ID: <20140825124218.GH28815@gondor.apana.org.au>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 05:37:04PM +0200, Stephan Mueller wrote:
> Hi,
> 
> The following patch set contains random fixes to increase the efficiency of
> the DRBG. Changes include the removal of unneeded memset(0) and sanity
> checks. All changes do not weaken the implementation as only code is
> removed that is clearly covered by other code paths.
> 
> In addition, the cpu_to_be kernel function together with a type cast is
> used to convert an integer into its string representation. This patch
> increases the speed of the DRBG by 10%.
> 
> Stephan Mueller (8):
>   DRBG: replace int2byte with cpu_to_be
>   DRBG: kzfree does not need a check for NULL pointer
>   DRBG: remove superflowous checks
>   DRBG: remove superflowous memset(0)
>   DRBG: use kmalloc instead of kzalloc for V and C
>   DRBG: remove unnecessary sanity checks
>   DRBG: remove configuration of fixed values
>   DRBG: remove unnecessary sanity check for shadow state

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

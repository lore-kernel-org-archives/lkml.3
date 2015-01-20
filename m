Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbbATDRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:17:17 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44195 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbbATDRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:17:14 -0500
Date: Tue, 20 Jan 2015 14:17:04 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Message-ID: <20150120031704.GB10475@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2587101.YvN0IxRmOH@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:56:03PM +0100, Stephan Mueller wrote:
> The cipher registered as __driver-gcm-aes-aesni is never intended
> to be used directly by any caller. Instead it is a service mechanism to
> rfc4106-gcm-aesni.
> 
> The kernel crypto API unconditionally calls the registered setkey
> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> call to crypto_aead_setkey will cause a NULL pointer dereference without
> this patch.
> 
> CC: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Rather than adding a bogus setkey function, please fix this mess
properly by moving the top-level setkey function into the __driver
one where it should be.  Compare with how we handle it in the
ablk_helper which is pretty much the same thing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

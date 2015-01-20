Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbbATDhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:37:15 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33844 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbATDhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:37:12 -0500
Date: Tue, 20 Jan 2015 14:37:05 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Message-ID: <20150120033704.GB10814@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
 <20150120031704.GB10475@gondor.apana.org.au>
 <1490816.1NddvTAE2F@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490816.1NddvTAE2F@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:35:41AM +0100, Stephan Mueller wrote:
>
> This in turn would then turn the __driver implementation into a full GCM 
> implementation. That would mean that we should rename it from __driver 
> into gcm(aes) / gcm-aesni. 

No you shouldn't because it'll fail in interrupt context where
you cannot use those special instructions.

The whole point of this setup is to use accelerated instructions
where possible, and otherwise fall back to a separate thread
where we can do so safely.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

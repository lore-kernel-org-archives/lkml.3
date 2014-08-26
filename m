Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbaHZInz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:43:55 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52635 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaHZInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:43:53 -0400
Date: Tue, 26 Aug 2014 16:43:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: fix maximum value checks on 32 bit systems
Message-ID: <20140826084343.GA4417@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
 <1998203.8HHRdZPLvI@myon.chronox.de>
 <20140826080858.GA4161@gondor.apana.org.au>
 <2984929.nIbTCa5fhe@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2984929.nIbTCa5fhe@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:29:45AM +0200, Stephan Mueller wrote:
> The maximum values for additional input string or generated blocks is
> larger than 1<<32. To ensure a sensible value on 32 bit systems, return
> SIZE_MAX on 32 bit systems. This value is lower than the maximum
> allowed values defined in SP800-90A. The standard allow lower maximum
> values, but not larger values.
> 
> SIZE_MAX - 1 is used for drbg_max_addtl to allow
> drbg_healthcheck_sanity to check the enforcement of the variable
> without wrapping.

This is really ugly but OK.  However, I'm not sure how the sanity
check ever worked.  It would appear that the drbg_generate call in
drbg_healthcheck_sanity should always fail because you explicitly
set addtl->len to drbg_max_addtl + 1, which should trigger the
"DRBG: additional information string too long" error, no?

Obviously it's working for you but I'd like to understand why
it's working and whether it'll continue to work.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

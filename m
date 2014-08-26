Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbaHZIJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:09:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45531 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaHZIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:09:06 -0400
Date: Tue, 26 Aug 2014 16:08:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DRBG: fix maximum value checks on 32 bit systems
Message-ID: <20140826080858.GA4161@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
 <6371777.WdUEAKFPYo@myon.chronox.de>
 <20140826073219.GA3880@gondor.apana.org.au>
 <1998203.8HHRdZPLvI@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1998203.8HHRdZPLvI@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:06:52AM +0200, Stephan Mueller wrote:
> The maximum values for additional input string or generated blocks is
> larger than 1<<32. To ensure a sensible value on 32 bit systems, return
> SIZE_MAX on 32 bit systems. This value is lower than the maximum allowed
> values defined in SP800-90A. The standard allow lower maximum values,
> but not larger values.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Unfortunately there's a place in drbg where you add one to
drbg_max_addtl which will cause it to overflow back to zero.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

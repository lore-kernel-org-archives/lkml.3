Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaHZGiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:38:20 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:51491 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZGiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:38:18 -0400
Date: Tue, 26 Aug 2014 14:38:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: linux-next: build warnings after merge of the crypto tree
Message-ID: <20140826063812.GA3555@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826161456.7ad100e3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:14:56PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto tree, today's linux-next build (powerpc
> ppc44x_defconfig, i386 defconfig and sparc defconfig) produced these
> warnings:
> 
> In file included from crypto/testmgr.c:30:0:
> include/crypto/drbg.h: In function 'drbg_max_addtl':
> include/crypto/drbg.h:157:2: warning: left shift count >= width of type
>   return (1UL<<35);
>   ^
> include/crypto/drbg.h: In function 'drbg_max_requests':
> include/crypto/drbg.h:163:2: warning: left shift count >= width of type
>   return (1UL<<48);
>   ^
> 
> Introduced by commit 05c81ccd9087 ("crypto: drbg - remove configuration
> of fixed values").  These are all 32 bit builds.

Stephan, could you take a look at this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

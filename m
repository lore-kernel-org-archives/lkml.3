Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbbAEKcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:32:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34807 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEKcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:32:07 -0500
Date: Mon, 5 Jan 2015 21:31:59 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] crypto: AF_ALG: add AEAD support
Message-ID: <20150105103159.GA24878@gondor.apana.org.au>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de>
 <1609020.xcc11L81HZ@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609020.xcc11L81HZ@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 03:41:33PM +0100, Stephan Mueller wrote:
>
> +		if (!con.aead_assoclen)
> +			return -EINVAL;

AD being zero should be fine.

> +		/* aead_recvmsg limits the maximum AD size to one page */
> +		if (con.aead_assoclen > PAGE_SIZE)
> +			return -E2BIG;

I don't see any need to limit the size of the AD.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

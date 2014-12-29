Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaL2Kdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:33:31 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44561 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaL2Kd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:33:29 -0500
Date: Mon, 29 Dec 2014 21:33:19 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Message-ID: <20141229103319.GB13334@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <5002301.TQO37u96dE@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5002301.TQO37u96dE@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 11:01:47PM +0100, Stephan Mueller wrote:
>
> +	err = -ENOMEM;

This should be EINVAL.

> +	if (!aead_sufficient_data(ctx))
> +		goto unlock;

So we're checking two things here, one that we have enough data
for AD and two we have the authentication tag.  The latter is
redundant as the underlying implementation should be able to cope
with short input so we should only check the assoclen here.

Also this check should be moved to the sendmsg side as that'll
make it more obvious as to what went wrong.

PS we should add a length check for missing/partial auth tags
to crypto_aead_decrypt.  We can then remove such checks from
individual implementations.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

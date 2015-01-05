Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbbAEKzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:55:46 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56734 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbbAEKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:55:43 -0500
Date: Mon, 5 Jan 2015 21:55:40 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Message-ID: <20150105105540.GA25665@gondor.apana.org.au>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de>
 <7639295.Yx6QIQScqO@tachyon.chronox.de>
 <20150105103957.GA25307@gondor.apana.org.au>
 <1656062.b6mnFyMzhb@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656062.b6mnFyMzhb@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:53:38AM +0100, Stephan Mueller wrote:
>
> Could you please check: I am unable to find the function.

It's in crypto/authenc.c.

> Note, there is no size parameter provided in crypto_aead_decrypt. To obtain 
> the size, I would need to walk the scatterlists, no?

The cryptlen is supposed to contain the entire input apart from the
AD, including the authentication tag if one is present.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

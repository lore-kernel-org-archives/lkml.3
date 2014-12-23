Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaLWL4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:56:38 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35312 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaLWL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:56:35 -0500
Date: Tue, 23 Dec 2014 22:56:26 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Message-ID: <20141223115626.GA31450@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3151022.sz5v21Vqeg@tachyon.chronox.de>
 <20141222112341.GA19532@gondor.apana.org.au>
 <101382546.xjTjAHLGAb@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <101382546.xjTjAHLGAb@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 09:14:43AM +0100, Stephan Mueller wrote:
>
> - the check aead_readable() immediately before this check implements the 
> blocking if we do not have sufficient data *and* more data is to be expected

Good point.

In fact AEAD is rather awkward because you need to do everything
in one go.  Perhaps we could adapt our kernel interface to allow
partial AEAD operations?

I want to be very careful before we pin down our user-space
interface since that's something that we cannot easily change
while the kernel interface can be modified at any time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

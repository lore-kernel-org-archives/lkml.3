Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaLWUYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:24:49 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59863 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaLWUYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:24:46 -0500
Date: Wed, 24 Dec 2014 07:24:01 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Message-ID: <20141223202401.GA2474@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <101382546.xjTjAHLGAb@tachyon.chronox.de>
 <20141223115626.GA31450@gondor.apana.org.au>
 <4537021.IXSvIIgcH4@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4537021.IXSvIIgcH4@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 03:52:27PM +0100, Stephan Mueller wrote:
> Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:
>
> > In fact AEAD is rather awkward because you need to do everything
> > in one go.  Perhaps we could adapt our kernel interface to allow
> > partial AEAD operations?
> 
> 
> I am not sure what you are referring to. The invocation does not need to be in 
> one go. You can have arbitrary number of sendmsg calls. But all input data 
> needs to be supplied before you call recvmsg.

What I mean is that unlike skcipher we cannot precede until we
have the complete input.  So you cannot begin recvmsg until all
input has been sent.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

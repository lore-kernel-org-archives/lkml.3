Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLYI7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 03:59:51 -0500
Received: from mail.eperm.de ([89.247.134.16]:51034 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaLYI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 03:59:46 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Thu, 25 Dec 2014 09:59:41 +0100
Message-ID: <4303878.9KB6gYbbHH@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <2159528.zCJB0y2Cap@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <20141223202401.GA2474@gondor.apana.org.au> <2159528.zCJB0y2Cap@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Dezember 2014, 09:54:33 schrieb Stephan Mueller:

Hi Stephan,

> Am Mittwoch, 24. Dezember 2014, 07:24:01 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Dec 23, 2014 at 03:52:27PM +0100, Stephan Mueller wrote:
> > > Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:
> > > > In fact AEAD is rather awkward because you need to do everything
> > > > in one go.  Perhaps we could adapt our kernel interface to allow
> > > > partial AEAD operations?
> > > 
> > > I am not sure what you are referring to. The invocation does not need to
> > > be in one go. You can have arbitrary number of sendmsg calls. But all
> > > input data needs to be supplied before you call recvmsg.
> > 
> > What I mean is that unlike skcipher we cannot precede until we
> > have the complete input.  So you cannot begin recvmsg until all
> > input has been sent.
> 
> That is right, but isn't that the nature of AEAD ciphers in general? Even if
> you are in the kernel, you need to have all scatter lists together for one
> invocation of the AEAD cipher.
> 
> In case of a threaded application, the recvmsg does not start until all data
> is in, marked with the missing MSG_MORE -- see aead_readable.
> 
> All we can do is allow the user to use multiple system calls to collect all
> data before the AEAD operation takes place.
> 
> Or do you see another way on how to invoke the AEAD operation in a different
> manner?
> 
> The only item that I see that could be made better is the output side:
> currently the code allows only one and exactly one iovec to point to the
> output buffer. I would like to allow multiple iovec buffers that are filled
> with the output of one invocation of the AEAD operation. However, to avoid
> making a kernel-internal scratch buffer, I would need to somehow link the
> kernel-internal scatter lists with the iovec buffers. That only works when
> walking the iovec lists first and call af_alg_make_sg with every iovec entry
> and create the kernel-internal scatterlist representation. That is followed
> by the AEAD operation on the scatterlist.
> 
> If we agree on walking the iovec list first, then the question arises how
> many iovec list entries we allow at max. Is 16 entries a sensible value?

I would be now ready with a new release of the AEAD and RNG interface patches 
against the current code base (including the iov_iter update). Though, I would 
like to get your answer regarding your concerns.

Thanks.

-- 
Ciao
Stephan

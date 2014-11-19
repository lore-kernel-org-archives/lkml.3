Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaKSAe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:34:27 -0500
Received: from mail.eperm.de ([89.247.134.16]:54626 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbaKSAe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:34:26 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for AEAD
Date: Wed, 19 Nov 2014 01:34:20 +0100
Message-ID: <2161216.flt1JCFqfn@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141118140631.GA12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <11608519.pS4L9VjM2n@tachyon.chronox.de> <20141118140631.GA12100@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. November 2014, 22:06:31 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 16, 2014 at 03:23:50AM +0100, Stephan Mueller wrote:
> > AEAD requires the following data in addition to normal symmetric
> > 
> > ciphers:
> > 	* Associated authentication data of arbitrary length
> > 	
> > 	* Authentication tag for decryption
> > 	
> > 	* Length of authentication tag for encryption
> > 
> > The authentication tag data is communicated as part of the actual
> > ciphertext as mandated by the kernel crypto API. Therefore we only need
> > to provide a user space interface for the associated authentication data
> > as well as for the authentication tag length.
> > 
> > This patch adds both as a setsockopt interface that is identical to the
> > AF_ALG interface for setting an IV and for selecting the cipher
> > operation type (encrypt or decrypt).
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> I don't like the fact that we're putting arbitrary limits on
> the AD, as well as the fact that the way you're doing it the
> AD has to be copied.
> 
> How about simply saying that the first X bytes of the input
> shall be the AD?

That is a very good idea.

To cover that approach, the kernel needs to be informed about the length of 
the authentication data size to separate the ciphertext/plaintext from the 
authentication data.

To cover that, I would recommend to simply send a u32 value to the kernel for 
the AD size instead of the AD. The kernel then can adjust the pointers as 
necessary.

I will update the patch in the next days to cover that scenario.

Thanks

-- 
Ciao
Stephan

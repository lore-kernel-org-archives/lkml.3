Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaKCOSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:18:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:54275 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaKCOSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:18:35 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level spec
Date: Mon, 03 Nov 2014 15:18:29 +0100
Message-ID: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.17.1-302.fc21.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20141103083439.635f5cb6@lwn.net>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de> <4163724.RCMDlx8dmE@tachyon.chronox.de> <20141103083439.635f5cb6@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. November 2014, 08:34:39 schrieb Jonathan Corbet:

Hi Jonathan,

> On Sun, 02 Nov 2014 21:35:11 +0100
> 
> Stephan Mueller <smueller@chronox.de> wrote:
> > The design of the kernel crypto API as well as hints to program with
> > the kernel crypto API are given.
> 
> Cool to see this, thanks.  Please forgive me if I go into full grumpy
> editor mode here.  There's a lot of good information here, but I think it
> could be made better with a bit of effort...

Thanks for your comments.

I will include your suggestions into a new patch set. Once you staring at that 
documentation for too long, you will not find errors any more :-)

[...]

> > +
> > + * CRYPTO_ALG_TYPE_CIPHER	Raw block cipher
> > + * CRYPTO_ALG_TYPE_COMPRESS	Compression
> > + * CRYPTO_ALG_TYPE_AEAD		Authenticated Encryption with 
Associated Data
> > (MAC) + * CRYPTO_ALG_TYPE_BLKCIPHER	Synchronous multi-block cipher
> > + * CRYPTO_ALG_TYPE_ABLKCIPHER	Asynchronous multi-block cipher
> > + * CRYPTO_ALG_TYPE_GIVCIPHER
> 
> What's this one?

I would like to ask Herbert what that is -- I looked around in the code and I 
am not sure what that flag shall indicate.
> 
> > + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
> > + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
> > + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
> > + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
> > + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
> > + * CRYPTO_ALG_TYPE_PCOMPRESS
> 
> What's that last one?

Same here.

[...]

> > +Specifics of asynchronous multi-block cipher
> > +............................................
> > +
> > +There are a couple of specifics to the [ABLKCIPHER] interface.
> > +
> > +First of all, some of the drivers will want to use the Generic
> > ScatterWalk
> > +in case the hardware needs to be fed separate chunks of the scatterlist
> > +which contains the plaintext and will contain the ciphertext. Please
> > refer
> > +below for a description and usage of the Generic ScatterWalk interface.
> > +
> > +It is recommended to enqueue cryptographic transformation requests into
> > +generic crypto queues. This allows for these requests to be processed in
> > +sequence as the cryptographic hardware becomes free.
> 
> What's a generic crypto queue?  That's a new concept.

Right. I do not claim to have all completed right from the start. If so, there 
is much more: the AEAD and RNG implementation details are missing here too.

Therefore, I thought I could leave it open for the moment to add in later.

[..]
> 
> These are all useful.  But I wonder if it would be worth the effort to turn
> this inti a proper docbook document that automatically has everything
> together in one place?

How do you suggest that is done? The API comments in the header file follow 
the Doxygen style. Note, Jason Cooper raised the concern that an API 
documentation separate from the code will surely deviate from the code 
relatively fast (although I do not really fear that as the kernel crypto API 
seems to be quite stable over the last years).

Can you point me to an example about what you have in mind? I see the 
Documentation/DocBook/ files, but I do not see how they integrate Doxygen-like 
source code comments added to functions.
> 
> > +
> > +Authors
> > +=======
> > +
> > +Stephan Mueller <smueller@chronox.de>
> > +Marek Vasut <marex@denx.de>
> 
> jon


-- 
Ciao
Stephan

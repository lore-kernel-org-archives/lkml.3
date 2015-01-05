Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbbAEKhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:37:40 -0500
Received: from mail.eperm.de ([89.247.134.16]:59358 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbbAEKhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:35 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 05 Jan 2015 11:26:48 +0100
Message-ID: <7639295.Yx6QIQScqO@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150105101901.GA24736@gondor.apana.org.au>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de> <20150105101901.GA24736@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 5. Januar 2015, 21:19:01 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 30, 2014 at 10:16:03PM +0100, Stephan Mueller wrote:
> > The AEAD decryption operation requires the authentication tag to be
> > present as part of the cipher text buffer. The added check verifies that
> > the caller provides a cipher text buffer with at least the
> > authentication tag.
> > 
> > As the cipher text is provided as a scatterlist, loop through the
> > scatterlist until we know we have sufficient cipher text bytes to invoke
> > the AEAD decryption operation.
> 
> There is no need to vet the scatterlist.  For kernel users it's
> up to them to ensure that the length is valid with respect to the
> sg list.
> 
> For the user-space interface obviously you should ensure that a
> valid length is supplied.

Then it seems I misunderstood you in your last comments. I thought the check 
that the authentication tag is present should be moved to the crypto API so 
that all users benefit from it.

As the authentication tag is "inline" in the ciphertext data stream, the only 
way I see to check for its presence is to verify that sufficient ciphertext is 
provided.

If the AEAD user space interface should perform the check, then the code drop 
provided with patch v6 would already cover that.

Could you please help me understand where that check should be and what should 
be done at the crypto API level?

Thanks

-- 
Ciao
Stephan

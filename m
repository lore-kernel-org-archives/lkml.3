Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJPB24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:28:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55944 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaJPB2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:28:54 -0400
Date: Thu, 16 Oct 2014 09:28:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: randconfig build error with next-20141015, in crypto
Message-ID: <20141016012840.GA7943@gondor.apana.org.au>
References: <CA+r1Zhj1nYEoP22cTQ71poxLU6zF2OZHbTarPFhOfwU8ddM7Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1Zhj1nYEoP22cTQ71poxLU6zF2OZHbTarPFhOfwU8ddM7Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 04:24:20PM -0700, Jim Davis wrote:
> This looks like a similar problem to one reported in August
> (https://lists.01.org/pipermail/kbuild-all/2014-August/006021.html),
> but there are significantly more errors this time.   Random
> configuration file attached:
> 
> crypto/built-in.o: In function `crypto_ctr_free':
> ctr.c:(.text+0x41): undefined reference to `crypto_drop_spawn'

Something is wrong with your test because your config file is
inconsistent with the current Kconfig description.  In particular,
you've got CRYPTO_CTR=y and CRYPTO_BLKCIPHER=m and yet in our
Kconfig CRYPTO_CTR explicitly selects CRYPTO_BLKCIPHER.

If you're just doing a simple make then this could be a bug in the
kbuild system.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

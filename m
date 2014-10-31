Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbaJaKGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:06:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36819 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbaJaKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:06:13 -0400
Date: Fri, 31 Oct 2014 18:05:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141031100522.GA8655@gondor.apana.org.au>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031095706.GA8054@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:57:06AM +0100, Maxime Ripard wrote:
>
> On a 3.18-rc2 kernel:
> 
> $ git grep kmap -- crypto/
> crypto/ahash.c:                         walk->data = kmap(walk->pg);
> crypto/ahash.c:                         walk->data = kmap_atomic(walk->pg);
> crypto/async_tx/async_memcpy.c:         dest_buf = kmap_atomic(dest) + dest_offset;
> crypto/async_tx/async_memcpy.c:         src_buf = kmap_atomic(src) + src_offset;
> crypto/scatterwalk.c:                   return kmap_atomic(scatterwalk_page(walk)) +
> crypto/shash.c:                         data = kmap_atomic(sg_page(sg));
> crypto/shash.c:                         data = kmap_atomic(sg_page(sg));
> 
> None of the drivers are.

What do you mean? It's precisely because the page can be in highmem
that we are mapping it.  If it's not in highmem it'll be a noop.

Admittedly I haven't tested highmem since moving over to x86-64
some years ago, but it definitely used to work on x86-32.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

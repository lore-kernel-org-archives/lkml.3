Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaFHC44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 22:56:56 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:47320 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaFHC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 22:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140605062336.GA14440@gondor.apana.org.au>
References: <20110724011752.GA14373@gondor.apana.org.au>
	<20111031040952.GA19659@gondor.apana.org.au>
	<20120106041250.GA7759@gondor.apana.org.au>
	<20121004095357.GA11777@gondor.apana.org.au>
	<20121214103156.GA5840@gondor.apana.org.au>
	<20130223023331.GA11002@gondor.apana.org.au>
	<20130907035544.GA22658@gondor.apana.org.au>
	<20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
Date: Sat, 7 Jun 2014 19:56:53 -0700
X-Google-Sender-Auth: UV-W-snJJsk0Wyz019MRM4uKAkE
Message-ID: <CA+55aFz0d4N5hcjqPxzz894WMaoYxBX7rLWXnCa12z=9ogacTg@mail.gmail.com>
Subject: Re: Crypto Update for 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Sonic Zhang <sonic.zhang@analog.com>, Steven Miao <realmz6@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 11:23 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 3.16:

There's something odd going on with bfin_crc.h.

You moved it in commit 52e6e543f2d8 ("crypto: bfin_crc - access crc
registers by readl and writel functions").

It got *deleted* by commit 3356c99ea392 ("bfin_crc: Move architecture
independant crc header file out of the blackfin folder") which claims
to just move things.

Both of those commits are by Sonic Zhang, just came to me through two
different trees (though your crypto tree, and through Steven Miao's
bfin tree).

I'm assuming that the delete was actually incorrect, and should have
been a move, because it looks like the bfin_crc.c file won't compile
without it. So I've re-instated that file.

But the state of the bfin tree seems to be crap. Somebody should take
a look at what happened here. My suspicion is that commit 3356c99ea392
was broken by Steven Miao trying to only touch files in arch/blackfin
or something.

               Linus

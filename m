Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3IMLbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:31:00 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58816 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418Ab3IMLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:30:58 -0400
Date: Fri, 13 Sep 2013 21:30:52 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.12
Message-ID: <20130913113051.GA8189@gondor.apana.org.au>
References: <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328082841.GA7425@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a 7+ year race condition in the crypto API that
causes sporadic crashes when multiple threads load the same
algorithm.

It also fixes the crct10dif algorithm again to prevent boot
failures on systems where the initramfs tool ignores module
softdeps.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (2):
      crypto: api - Fix race condition in larval lookup
      crypto: crct10dif - Add fallback for broken initrds

 crypto/Makefile                             |    2 +-
 crypto/api.c                                |    7 +-
 crypto/{crct10dif.c => crct10dif_common.c}  |  100 +--------------------------
 crypto/{crct10dif.c => crct10dif_generic.c} |   53 +-------------
 lib/crc-t10dif.c                            |   11 ++-
 5 files changed, 20 insertions(+), 153 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3GXHXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:23:14 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:42439 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab3GXHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:23:12 -0400
Date: Wed, 24 Jul 2013 17:23:07 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.11
Message-ID: <20130724072307.GA31136@gondor.apana.org.au>
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

This push fixes a memory corruption issue in caam, as well as
reverting the new optimised crct10dif implementation as it breaks
boot on initrd systems.

Hopefully crct10dif will be reinstated once the supporting code
is added so that it doesn't break boot.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      Revert "crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework"

Vakul Garg (1):
      crypto: caam - Fixed the memory out of bound overwrite issue

 arch/x86/crypto/Makefile                |    2 -
 arch/x86/crypto/crct10dif-pcl-asm_64.S  |  643 -------------------------------
 arch/x86/crypto/crct10dif-pclmul_glue.c |  151 --------
 crypto/Kconfig                          |   19 -
 crypto/Makefile                         |    1 -
 crypto/crct10dif.c                      |  178 ---------
 crypto/tcrypt.c                         |    8 -
 crypto/testmgr.c                        |   10 -
 crypto/testmgr.h                        |   33 --
 drivers/crypto/caam/caamhash.c          |    2 +-
 include/linux/crc-t10dif.h              |    4 -
 lib/Kconfig                             |    2 -
 lib/crc-t10dif.c                        |   73 ++--
 13 files changed, 44 insertions(+), 1082 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

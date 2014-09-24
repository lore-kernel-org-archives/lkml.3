Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaIXN1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:27:31 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52845 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaIXN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:27:30 -0400
Date: Wed, 24 Sep 2014 21:27:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.17
Message-ID: <20140924132720.GA31661@gondor.apana.org.au>
References: <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140710090314.GA15729@gondor.apana.org.au>
 <20140915113506.GA4736@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915113506.GA4736@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes three issues:

* If ccp is loaded on a machine without ccp, it will incorrectly
activate causing all requests to fail.  Fixed by preventing ccp
from loading if hardware isn't available.

* Not all IRQs were enabled for the qat driver, leading to potential
stalls when it is used.

* Disabled buggy AVX CTR implementation in aesni.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Mathias Krause (1):
      crypto: aesni - disable "by8" AVX CTR optimization

Tadeusz Struk (1):
      crypto: qat - Enable all 32 IRQs

Tom Lendacky (1):
      crypto: ccp - Check for CCP before registering crypto algs

 arch/x86/crypto/aesni-intel_glue.c                     |    4 ++--
 drivers/crypto/ccp/ccp-crypto-main.c                   |    4 ++++
 drivers/crypto/ccp/ccp-dev.c                           |   14 ++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +-
 include/linux/ccp.h                                    |   12 ++++++++++++
 5 files changed, 33 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

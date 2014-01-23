Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaAWLxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:53:30 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:39107 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaAWLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:53:28 -0500
Date: Thu, 23 Jan 2014 19:53:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.14
Message-ID: <20140123115319.GA20602@gondor.apana.org.au>
References: <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107080131.GA32307@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.14:

* Improved crypto_memneq helper.
* Use cyprto_memneq in arch-specific crypto code.
* Replaced orphaned DCP driver with Freescale MXS DCP driver.
* Added AVX/AVX2 version of AESNI-GCM encode and decode.
* Added AMD Cryptographic Coprocessor (CCP) driver.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git



Andy Shevchenko (1):
      crypto: aesni - fix build on x86 (32bit)

Cesar Eduardo Barros (1):
      crypto: more robust crypto_memneq

Daniel Borkmann (2):
      crypto: memneq - fix for archs without efficient unaligned access
      crypto: arch - use crypto_memneq instead of memcmp

Fengguang Wu (1):
      crytpo: ccp - fix coccinelle warnings

Horia Geanta (2):
      crypto: talitos - fix locating offending descriptor in error path
      crypto: caam - simplify and harden key parsing

Lokesh Vutla (1):
      crypto: omap-sham - Fix Polling mode for larger blocks

Marek Vasut (5):
      crypto: ahash - Fully restore ahash request before completing
      crypto: mxs - Remove the old DCP driver
      crypto: mxs - Add Freescale MXS DCP driver
      ARM: mxs: dts: Enable DCP for MXS
      crypto: drivers - Sort drivers/crypto/Makefile

Mark A. Greer (1):
      crypto: omap-sham - Only release DMA channel if successfully requested

Mathias Krause (2):
      crypto: pcrypt - Fix wrong usage of rcu_dereference()
      padata: Fix wrong usage of rcu_dereference()

Nishanth Menon (1):
      crypto: omap-aes - add error check for pm_runtime_get_sync

Sachin Kamat (3):
      crypto: crypto4xx - Remove redundant dev_set_drvdata
      crypto: ccp - Remove redundant dev_set_drvdata
      crypto: talitos - Remove redundant dev_set_drvdata

Tim Chen (3):
      crypto: aesni - AVX and AVX2 version of AESNI-GCM encode and decode
      crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in tcrypt test suite
      crypto: aesni - fix build on x86 (32bit)

Tom Lendacky (17):
      crypto: ccp - CCP device driver and interface support
      crypto: ccp - crypto API interface to the CCP device driver
      crypto: ccp - CCP AES crypto API support
      crypto: ccp - CCP AES CMAC mode crypto API support
      crypto: ccp - CCP XTS-AES crypto API support
      crypto: ccp - CCP SHA crypto API support
      crytpo: ccp - CCP device driver build files
      crypto: ccp - CCP maintainer information
      crypto: ccp - Fix sparse warnings in ccp-crypto-sha.c
      crypto: ccp - CCP Kconfig fixes
      crypto: ccp - Remove user triggerable pr_err calls
      crypto: ccp - Apply appropriate gfp_t type to memory allocations
      crypto: ccp - Cleanup scatterlist usage
      crypto: ccp - Check for caller result area before using it
      crypto: ccp - Change data length declarations to u64
      crypto: ccp - Cleanup hash invocation calls
      crypto: ccp - CCP device enabled/disabled changes

Wei Yongjun (1):
      crypto: mxs - Fix sparse non static symbol warning

 .../devicetree/bindings/crypto/fsl-dcp.txt         |   17 +
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/imx23.dtsi                       |    4 +-
 arch/arm/boot/dts/imx28.dtsi                       |    3 +-
 arch/s390/crypto/des_s390.c                        |    6 +-
 arch/x86/crypto/Makefile                           |    1 +
 arch/x86/crypto/aesni-intel_avx-x86_64.S           | 2811 ++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c                 |  147 +-
 crypto/Makefile                                    |    5 -
 crypto/ahash.c                                     |    5 +-
 crypto/memneq.c                                    |   80 +-
 crypto/pcrypt.c                                    |    2 +-
 crypto/tcrypt.c                                    |  270 ++
 crypto/tcrypt.h                                    |   10 +
 drivers/crypto/Kconfig                             |   39 +-
 drivers/crypto/Makefile                            |   33 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    1 -
 drivers/crypto/caam/caamalg.c                      |   36 +-
 drivers/crypto/ccp/Kconfig                         |   24 +
 drivers/crypto/ccp/Makefile                        |   10 +
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |  365 +++
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |  279 ++
 drivers/crypto/ccp/ccp-crypto-aes.c                |  369 +++
 drivers/crypto/ccp/ccp-crypto-main.c               |  432 +++
 drivers/crypto/ccp/ccp-crypto-sha.c                |  517 ++++
 drivers/crypto/ccp/ccp-crypto.h                    |  197 ++
 drivers/crypto/ccp/ccp-dev.c                       |  595 +++++
 drivers/crypto/ccp/ccp-dev.h                       |  272 ++
 drivers/crypto/ccp/ccp-ops.c                       | 2024 ++++++++++++++
 drivers/crypto/ccp/ccp-pci.c                       |  361 +++
 drivers/crypto/dcp.c                               |  903 -------
 drivers/crypto/mxs-dcp.c                           | 1100 ++++++++
 drivers/crypto/omap-aes.c                          |   16 +-
 drivers/crypto/omap-sham.c                         |   19 +-
 drivers/crypto/talitos.c                           |   23 +-
 include/linux/ccp.h                                |  537 ++++
 include/linux/compiler-gcc.h                       |    3 +
 include/linux/compiler-intel.h                     |    7 +
 include/linux/compiler.h                           |    4 +
 kernel/padata.c                                    |    2 +-
 40 files changed, 10527 insertions(+), 1009 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

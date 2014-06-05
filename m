Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaFEGXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:23:52 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57009 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaFEGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:23:50 -0400
Date: Thu, 5 Jun 2014 14:23:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.16
Message-ID: <20140605062336.GA14440@gondor.apana.org.au>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401100001.GA12386@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.16:

* Added test vectors for SHA/AES-CCM/DES-CBC/3DES-CBC.
* Fixed a number of error-path memory leaks in tcrypt.
* Fixed error-path memory leak in caam.
* Removed unnecessary global mutex from mxs-dcp.
* Added ahash walk interface that can actually be asynchronous.
* Cleaned up caam error reporting.
* Allow crypto_user get operation to be used by non-root users.
* Add support for SSS module on Exynos.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git


Alexander Gordeev (1):
      crypto: ccp - Use pci_enable_msix_range() instead of pci_enable_msix()

Ard Biesheuvel (1):
      crypto: testmgr - add test cases for SHA-1, SHA-224, SHA-256 and AES-CCM

Arnd Bergmann (1):
      crypto: s5p-sss - fix multiplatform build

Christian Engelmayer (3):
      crypto: tcrypt - Fix potential leak in test_aead_speed() if aad_size is too big
      crypto: tcrypt - Fix potential leak in test_aead_speed() if crypto_alloc_aead() fails
      crypto: tcrypt - Fix leak of struct aead_request in test_aead_speed()

Fabio Estevam (1):
      crypto: mxs-dcp - Remove global mutex

Herbert Xu (2):
      crypto: ghash-clmulni-intel - Use u128 instead of be128 for internal key
      crypto: hash - Add real ahash walk interface

Himangi Saraogi (1):
      hwrng: n2-drv - Introduce the use of the managed version of kzalloc

Horia Geanta (1):
      crypto: caam - fix mem leak in ahash_setkey

Jean Delvare (3):
      hwrng: Move UML_RANDOM at the last position
      hwrng: Turn HW_RANDOM into a menuconfig
      hwrng: Fix a few driver dependencies and defaults

Jingoo Han (3):
      crypto: omap-des - use devm_ioremap_resource()
      hwrng: omap - remove unnecessary OOM messages
      hwrng: timeriomem - remove unnecessary OOM messages

Jussi Kivilinna (1):
      crypto: testmgr - add empty and large test vectors for SHA-1, SHA-224, SHA-256, SHA-384 and SHA-512

Leilei Zhao (2):
      crypto: atmel-aes - correct block size of cfb8 mode
      crypto: atmel-aes - check alignment of cfb64 mode

Marek Vasut (23):
      crypto: caam - Contain caam_jr_strstatus() ugliness
      crypto: caam - Pull all the error codes out
      crypto: caam - Implement fast-path for error codes with no handler
      crypto: caam - Pass error type into the functions
      crypto: caam - Kill the easy targets
      crypto: caam - Dissolve report_jump_idx()
      crypto: caam - Clean up report_ccb_status()
      crypto: caam - Clean up report_deco_status()
      crypto: caam - Kill SPRINTFCAT() with fire
      crypto: caam - Sweep the remnants
      crypto: caam - Fix the 'quoted string split across lines'
      crypto: geode - Kill AES_MIN_BLOCK_SIZE
      crypto: geode - Kill AES_IV_LENGTH
      crypto: geode - Consistently use AES_KEYSIZE_128
      crypto: geode - Weed out printk() from probe()
      crypto: geode - Don't use tfm->__crt_alg->cra_name directly
      crypto: ccp - tfm->__crt_alg->cra_name directly
      crypto: cesa - tfm->__crt_alg->cra_name directly
      crypto: dcp - tfm->__crt_alg->cra_name directly
      crypto: n2 - tfm->__crt_alg->cra_name directly
      crypto: padlock - tfm->__crt_alg->cra_name directly
      crypto: sahara - tfm->__crt_alg->cra_name directly
      crypto: cesa - tfm->__crt_alg->cra_type directly

Matthias-Christian Ott (1):
      crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN

Monam Agarwal (1):
      crypto: nx - Use RCU_INIT_POINTER(x, NULL)

Naveen Krishna Chatradhi (7):
      crypto: s5p-sss - Use platform_get_irq() instead of _byname()
      crypto: s5p-sss - Add device tree support
      crypto: s5p-sss - Add support for SSS module on Exynos
      crypto: s5p-sss - Let Exynos SoCs select SSS driver
      crypto: s5p-sss - validate iv before memcpy
      crypto: s5p-sss - Use clk_prepare/clk_unprepare
      crypto: s5p-sss - Look for the next request in the queue

Nishanth Menon (1):
      crypto: omap-des - handle error of pm_runtime_get_sync

Nitesh Lal (1):
      crypto: testmgr - add aead cbc des, des3_ede tests

Paul Bolle (1):
      hwrng: picoxcell - remove unbuildable picoxcell TRNG

Sonic Zhang (3):
      crypto: bfin_crc - access crc registers by readl and writel functions
      crypto: bfin_crc - ignore duplicated registration of the same algorithm
      cryptoo: bfin_crc - avoid get physical address of coherence memory by dma_map_single

Tadeusz Struk (1):
      crypto: testmgr - Fix DMA-API warning

Vakul Garg (1):
      crypto: caam - reinitialize keys_fit_inline for decrypt and givencrypt

 .../devicetree/bindings/crypto/samsung-sss.txt     |   34 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    4 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   12 +-
 crypto/ahash.c                                     |   41 +-
 crypto/crypto_user.c                               |   12 +-
 crypto/tcrypt.c                                    |   52 +-
 crypto/testmgr.c                                   |  181 ++-
 crypto/testmgr.h                                   | 1441 +++++++++++++++++++-
 drivers/char/hw_random/Kconfig                     |  103 +-
 drivers/char/hw_random/Makefile                    |    1 -
 drivers/char/hw_random/n2-drv.c                    |   24 +-
 drivers/char/hw_random/omap-rng.c                  |    4 +-
 drivers/char/hw_random/picoxcell-rng.c             |  181 ---
 drivers/char/hw_random/timeriomem-rng.c            |    4 +-
 drivers/crypto/Kconfig                             |    6 +-
 drivers/crypto/atmel-aes.c                         |    8 +-
 drivers/crypto/bfin_crc.c                          |  103 +-
 .../include/asm => drivers/crypto}/bfin_crc.h      |    0
 drivers/crypto/caam/caamalg.c                      |   31 +-
 drivers/crypto/caam/caamhash.c                     |   32 +-
 drivers/crypto/caam/caamrng.c                      |    7 +-
 drivers/crypto/caam/error.c                        |  389 +++---
 drivers/crypto/caam/error.h                        |    2 +-
 drivers/crypto/caam/key_gen.c                      |    7 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |    4 +-
 drivers/crypto/ccp/ccp-pci.c                       |    7 +-
 drivers/crypto/geode-aes.c                         |   28 +-
 drivers/crypto/geode-aes.h                         |    6 +-
 drivers/crypto/mv_cesa.c                           |    6 +-
 drivers/crypto/mxs-dcp.c                           |   52 +-
 drivers/crypto/n2_core.c                           |    4 +-
 drivers/crypto/nx/nx-842.c                         |    4 +-
 drivers/crypto/omap-des.c                          |   33 +-
 drivers/crypto/padlock-sha.c                       |    2 +-
 drivers/crypto/s5p-sss.c                           |  148 +-
 drivers/crypto/sahara.c                            |    2 +-
 include/crypto/internal/hash.h                     |   13 +
 37 files changed, 2245 insertions(+), 743 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

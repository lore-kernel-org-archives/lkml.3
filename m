Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDAKAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:00:13 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:46244 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDAKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:00:10 -0400
Date: Tue, 1 Apr 2014 18:00:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.15
Message-ID: <20140401100001.GA12386@gondor.apana.org.au>
References: <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123115319.GA20602@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.15:

* Added 3DES driver for OMAP4/AM43xx.
* Added AVX2 acceleration for SHA.
* Added hash-only AEAD algorithms in caam.
* Removed tegra driver as it is not functioning and the hardware is too slow.
* Allow blkcipher walks over AEAD (needed for ARM).
* Fixed unprotected FPU/SSE access in ghash-clmulni-intel.
* Fixed highmem crash in omap-sham.
* Add (zero entropy) randomness when initialising hardware RNGs.
* Fixed unaligned ahash comletion functions.
* Added soft module depedency for crc32c for initrds that use crc32c.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git



Alex Porosanu (1):
      crypto: caam - fix ERA retrieval function

Alexander Shiyan (1):
      crypto: sahara - Use return value of devm_request_irq() on error

Ard Biesheuvel (3):
      crypto: remove direct blkcipher_walk dependency on transform
      crypto: allow blkcipher walks over AEAD data
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Dan Carpenter (3):
      hwrng: cleanup in hwrng_register()
      crypto: remove a duplicate checks in __cbc_decrypt()
      crypto: caam - writel() arguments are swapped

Dave Jones (1):
      crypto: ccp - Fix ccp_run_passthru_cmd dma variable assignments

Fabio Estevam (3):
      crypto: mxs-dcp: Use devm_kzalloc()
      crypto: mxs-dcp: Check the return value of stmp_reset_block()
      crypto: mxs-dcp - Fix platform_get_irq() error handling

Herbert Xu (1):
      crypto: caam - Fix first parameter to caam_init_rng

Horia Geanta (5):
      crypto: caam - remove error propagation handling
      crypto: export NULL algorithms defines
      crypto: testmgr - add aead null encryption test vectors
      crypto: caam - add support for aead null encryption
      crypto: caam - add missing key_dma unmap

Jingoo Han (14):
      crypto: picoxcell - Use devm_ioremap_resource()
      crypto: sahara - Use devm_ioremap_resource()
      crypto: s5p-sss - Use devm_ioremap_resource()
      hwrng: atmel - Use devm_ioremap_resource()
      hwrng: pixocell - Use devm_ioremap_resource()
      hwrng: atmel - Use devm_clk_get()
      hwrng: omap3-rom - Use devm_clk_get()
      hwrng: pixocell - Use devm_clk_get()
      hwrng: nomadik - Use devm_*() functions
      hwrng: timeriomem - Use devm_*() functions
      crypto: omap-aes - Use SIMPLE_DEV_PM_OPS macro
      crypto: omap-des - Use SIMPLE_DEV_PM_OPS macro
      crypto: omap-sham - Use SIMPLE_DEV_PM_OPS macro
      crypto: omap-des - make local functions static

Joel Fernandes (3):
      crypto: omap-des - Add omap-des driver for OMAP4/AM43xx
      crypto: omap-des - Add config and build options
      crypto: omap-sham - Map SG pages if they are HIGHMEM before accessing

Kees Cook (1):
      hwrng: add randomness to system from rng sources

Kevin Hao (1):
      crypto: talitos: init the priv->alg_list more earlier in talitos_probe()

Marek Vasut (6):
      crypto: dcp - Move the AES operation type from actx to rctx
      crypto: mxs-dcp - Align the bounce buffers
      crypto: mxs-dcp - Optimize hashing
      crypto: hash - Fix the pointer voodoo in unaligned ahash
      crypto: hash - Pull out the functions to save/restore request
      crypto: hash - Simplify the ahash_finup implementation

Mathias Krause (3):
      crypto: x86/sha1 - re-enable the AVX variant
      crypto: x86/sha1 - fix stack alignment of AVX2 variant
      crypto: x86/sha1 - reduce size of the AVX2 asm implementation

Nitesh Lal (2):
      crypto: caam - Fix job ring discovery in controller driver
      crypto: caam - Dynamic memory allocation for caam_rng_ctx object

Sonic Zhang (1):
      crypt: bfin_crc - Remove useless SSYNC instruction and cache flush to DMA coherent memory

Stephen Warren (1):
      crypto: tegra - remove driver

Tim Chen (2):
      CRC32C: Add soft module dependency to load other accelerated crc32c modules
      crypto: crypto_wq - Fix late crypto work queue initialization

Tom Lendacky (7):
      crypto: ccp - Allow for selective disablement of crypto API algorithms
      crypto: ccp - Move HMAC calculation down to ccp ops file
      crypto: ccp - Use a single queue for proper ordering of tfm requests
      crypto: ccp - Perform completion callbacks using a tasklet
      crypto: ccp - Prevent a possible lost CCP command request
      crypto: ccp - Invoke context callback when there is a backlog error
      crypto: ccp - Account for CCP backlog processing

chandramouli narayanan (1):
      crypto: sha - SHA1 transform x86_64 AVX2

 arch/x86/crypto/Makefile                   |    3 +
 arch/x86/crypto/blowfish_glue.c            |    3 -
 arch/x86/crypto/cast5_avx_glue.c           |    3 -
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |   29 -
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   14 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S     |  708 ++++++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c          |   53 ++-
 crypto/Kconfig                             |    4 +-
 crypto/Makefile                            |    2 +-
 crypto/ahash.c                             |  147 +++--
 crypto/blkcipher.c                         |   81 ++-
 crypto/{crc32c.c => crc32c_generic.c}      |    2 +
 crypto/crypto_null.c                       |    6 +-
 crypto/crypto_wq.c                         |    2 +-
 crypto/tcrypt.c                            |    8 +
 crypto/testmgr.c                           |   32 +
 crypto/testmgr.h                           |  180 ++++
 drivers/char/hw_random/atmel-rng.c         |   23 +-
 drivers/char/hw_random/core.c              |   17 +-
 drivers/char/hw_random/nomadik-rng.c       |   13 +-
 drivers/char/hw_random/omap3-rom-rng.c     |    3 +-
 drivers/char/hw_random/picoxcell-rng.c     |   27 +-
 drivers/char/hw_random/timeriomem-rng.c    |   40 +-
 drivers/crypto/Kconfig                     |   22 +-
 drivers/crypto/Makefile                    |    2 +-
 drivers/crypto/bfin_crc.c                  |   45 +-
 drivers/crypto/caam/caamalg.c              |  384 ++++++++--
 drivers/crypto/caam/caamrng.c              |   17 +-
 drivers/crypto/caam/compat.h               |    1 +
 drivers/crypto/caam/ctrl.c                 |   61 +-
 drivers/crypto/caam/ctrl.h                 |    2 +-
 drivers/crypto/caam/desc_constr.h          |   27 +-
 drivers/crypto/caam/regs.h                 |    4 +-
 drivers/crypto/ccp/ccp-crypto-main.c       |  224 ++---
 drivers/crypto/ccp/ccp-crypto-sha.c        |  130 +---
 drivers/crypto/ccp/ccp-crypto.h            |    8 +-
 drivers/crypto/ccp/ccp-dev.c               |   21 +-
 drivers/crypto/ccp/ccp-ops.c               |  108 +++-
 drivers/crypto/mxs-dcp.c                   |   83 ++-
 drivers/crypto/omap-aes.c                  |    4 +-
 drivers/crypto/omap-des.c                  | 1216 ++++++++++++++++++++++++++++
 drivers/crypto/omap-sham.c                 |   12 +-
 drivers/crypto/picoxcell_crypto.c          |   16 +-
 drivers/crypto/s5p-sss.c                   |   13 +-
 drivers/crypto/sahara.c                    |   26 +-
 drivers/crypto/talitos.c                   |    4 +-
 drivers/crypto/tegra-aes.c                 | 1087 -------------------------
 drivers/crypto/tegra-aes.h                 |  103 ---
 include/crypto/algapi.h                    |    9 +-
 include/crypto/null.h                      |   11 +
 include/linux/ccp.h                        |    7 +
 51 files changed, 3140 insertions(+), 1907 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

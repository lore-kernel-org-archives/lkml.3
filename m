Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3EBBrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:47:15 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:44260 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932104Ab3EBBrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:47:10 -0400
Date: Thu, 2 May 2013 09:47:03 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.10
Message-ID: <20130502014703.GA2033@gondor.apana.org.au>
References: <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223023331.GA11002@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.10:

* XTS mode optimisation for twofish/cast6/camellia/aes on x86.
* AVX2/x86_64 implementation for blowfish/twofish/serpent/camellia.
* SSSE3/AVX/AVX2 optimisations for sha256/sha512.
* Added driver for SAHARA2 crypto accelerator.
* Fix for GMAC when used in non-IPsec secnarios.
* Added generic CMAC implementation (including IPsec glue).
* IP update for crypto/atmel.
* Support for more than one device in hwrng/timeriomem.
* Added Broadcom BCM2835 RNG driver.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexander Clouter (2):
      hwrng: timeriomem - update to support more than one device
      hwrng: timeriomem - added devicetree hooks

Fabio Estevam (1):
      hwrng: mxc-rnga - Use devm_ioremap_resource()

Herbert Xu (1):
      crypto: crc32c - Kill pointless CRYPTO_CRC32C_X86_64 option

Javier Martin (1):
      crypto: sahara - Add driver for SAHARA2 accelerator.

Jingoo Han (1):
      hwrng: exynos - add CONFIG_PM_SLEEP/CONFIG_PM_RUNTIME to suspend/resume

Joel A Fernandes (2):
      crypto: omap-sham - Use pm_runtime_put instead of pm_runtime_put_sync in tasklet
      crypto: omap-aes - Use pm_runtime_put instead of pm_runtime_put_sync in tasklet

Jussi Kivilinna (20):
      crypto: x86/crc32-pclmul - assembly clean-ups: use ENTRY/ENDPROC
      crypto: x86 - build AVX block cipher implementations only if assembler supports AVX instructions
      crypto: gcm - make GMAC work when dst and src are different
      crypto: gcm - fix rfc4543 to handle async crypto correctly
      crypto: testmgr - add AES GMAC test vectors
      crypto: testmgr - add empty test vectors for null ciphers
      crypto: add CMAC support to CryptoAPI
      xfrm: add rfc4494 AES-CMAC-96 support
      crypto: x86 - add more optimized XTS-mode for serpent-avx
      crypto: x86/twofish-avx - use optimized XTS code
      crypto: cast6-avx: use new optimized XTS code
      crypto: x86/camellia-aesni-avx - add more optimized XTS code
      crypto: aesni_intel - add more optimized XTS mode for x86-64
      crypto: aesni_intel - fix Kconfig problem with CRYPTO_GLUE_HELPER_X86
      crypto: testmgr - extend camellia test-vectors for camellia-aesni/avx2
      crypto: tcrypt - add async cipher speed tests for blowfish
      crypto: blowfish - add AVX2/x86_64 implementation of blowfish cipher
      crypto: twofish - add AVX2/x86_64 assembler implementation of twofish cipher
      crypto: serpent - add AVX2/x86_64 assembler implementation of serpent cipher
      crypto: camellia - add AVX2/AES-NI/x86_64 assembler implementation of camellia cipher

Kim Phillips (2):
      crypto: caam - change key gen functions to return signed int
      crypto: caam - static constify error data

Lubomir Rintel (1):
      hwrng: bcm2835 - Add Broadcom BCM2835 RNG driver

Mathias Krause (1):
      crypto: user - constify netlink dispatch table

Mihnea Dobrescu-Balaur (1):
      crypto: ux500 - replace kmalloc and then memcpy with kmemdup

Nicolas Royer (4):
      ARM: AT91SAM9G45: same platform data structure for all crypto peripherals
      crypto: atmel-aes - add support for latest release of the IP (0x130)
      crypto: atmel-tdes - add support for latest release of the IP (0x700)
      crypto: atmel-sha - add support for latest release of the IP (0x410)

Paul Bolle (1):
      crypto: caam - fix typo "CRYPTO_AHASH"

Sachin Kamat (3):
      crypto: omap-aes - Use module_platform_driver macro
      crypto: omap-sham - Use module_platform_driver macro
      crypto: picoxcell - Use of_match_ptr() macro

Sandy Wu (1):
      crypto: crc32-pclmul - Use gas macro for pclmulqdq

Syam Sidhardhan (1):
      crypto: bfin_crc - Fix possible NULL pointer dereference

Tang Chen (1):
      hwrng: Fix a wrong comment in Documentation/hw_random.txt

Tim Chen (11):
      crypto: crc32c - Update the links to the white papers on CRC32C calculations with PCLMULQDQ instructions.
      crypto: sha256 - Expose SHA256 generic routine to be callable externally.
      crypto: sha256 - Optimized sha256 x86_64 assembly routine using Supplemental SSE3 instructions.
      crypto: sha256 - Optimized sha256 x86_64 assembly routine with AVX instructions.
      crypto: sha256 - Optimized sha256 x86_64 routine using AVX2's RORX instructions
      crypto: sha256 - Create module providing optimized SHA256 routines using SSSE3, AVX or AVX2 instructions.
      crypto: sha512 - Expose generic sha512 routine to be callable from other modules
      crypto: sha512 - Optimized SHA512 x86_64 assembly routine using Supplemental SSE3 instructions.
      crypto: sha512 - Optimized SHA512 x86_64 assembly routine using AVX instructions.
      crypto: sha512 - Optimized SHA512 x86_64 assembly routine using AVX2 RORX instruction.
      crypto: sha512 - Create module providing optimized SHA512 routines using SSSE3, AVX or AVX2 instructions.

Vakul Garg (3):
      crypto: caam - set RDB bit in security configuration register
      crypto: caam - Fix missing init of '.type' in AEAD algos.
      crypto: caam - fix job ring cleanup code

Wei Yongjun (1):
      crypto: ux500 - fix error return code in hash_dma_final()

 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   15 +
 .../devicetree/bindings/hwrng/timeriomem_rng.txt   |   18 +
 .../devicetree/bindings/rng/brcm,bcm2835.txt       |   13 +
 Documentation/hw_random.txt                        |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   14 +-
 arch/x86/crypto/Makefile                           |   57 +-
 arch/x86/crypto/aesni-intel_asm.S                  |  117 ++
 arch/x86/crypto/aesni-intel_glue.c                 |   80 ++
 arch/x86/crypto/blowfish-avx2-asm_64.S             |  449 +++++++
 .../{blowfish_glue.c => blowfish_avx2_glue.c}      |  402 ++++---
 arch/x86/crypto/blowfish_glue.c                    |   32 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |  180 +++-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       | 1368 ++++++++++++++++++++
 ...aesni_avx_glue.c => camellia_aesni_avx2_glue.c} |  182 ++--
 arch/x86/crypto/camellia_aesni_avx_glue.c          |  104 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |   48 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   91 +-
 arch/x86/crypto/crc32-pclmul_asm.S                 |    6 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |   10 +-
 arch/x86/crypto/glue_helper-asm-avx.S              |   61 +-
 arch/x86/crypto/glue_helper-asm-avx2.S             |  180 +++
 arch/x86/crypto/glue_helper.c                      |   97 ++-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |   45 +-
 ...t-avx-x86_64-asm_64.S => serpent-avx2-asm_64.S} |  207 ++--
 .../{serpent_avx_glue.c => serpent_avx2_glue.c}    |  323 +++---
 arch/x86/crypto/serpent_avx_glue.c                 |  145 ++-
 arch/x86/crypto/sha256-avx-asm.S                   |  496 +++++++
 arch/x86/crypto/sha256-avx2-asm.S                  |  772 +++++++++++
 arch/x86/crypto/sha256-ssse3-asm.S                 |  506 ++++++++
 arch/x86/crypto/sha256_ssse3_glue.c                |  275 ++++
 arch/x86/crypto/sha512-avx-asm.S                   |  423 ++++++
 arch/x86/crypto/sha512-avx2-asm.S                  |  743 +++++++++++
 arch/x86/crypto/sha512-ssse3-asm.S                 |  421 ++++++
 arch/x86/crypto/sha512_ssse3_glue.c                |  282 ++++
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |   48 +-
 arch/x86/crypto/twofish-avx2-asm_64.S              |  600 +++++++++
 .../{twofish_avx_glue.c => twofish_avx2_glue.c}    |  269 ++--
 arch/x86/crypto/twofish_avx_glue.c                 |  101 +-
 arch/x86/include/asm/cpufeature.h                  |    1 +
 arch/x86/include/asm/crypto/blowfish.h             |   43 +
 arch/x86/include/asm/crypto/camellia.h             |   19 +
 arch/x86/include/asm/crypto/glue_helper.h          |   24 +
 arch/x86/include/asm/crypto/serpent-avx.h          |   29 +
 arch/x86/include/asm/crypto/twofish.h              |   18 +
 crypto/Kconfig                                     |  133 ++-
 crypto/Makefile                                    |    1 +
 crypto/cmac.c                                      |  315 +++++
 crypto/crypto_user.c                               |    4 +-
 crypto/gcm.c                                       |  116 ++-
 crypto/sha256_generic.c                            |   11 +-
 crypto/sha512_generic.c                            |   13 +-
 crypto/tcrypt.c                                    |   30 +-
 crypto/testmgr.c                                   |   95 ++-
 crypto/testmgr.h                                   | 1314 ++++++++++++++++++-
 drivers/char/hw_random/Kconfig                     |   12 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm2835-rng.c               |  113 ++
 drivers/char/hw_random/exynos-rng.c                |    3 +-
 drivers/char/hw_random/mxc-rnga.c                  |   21 +-
 drivers/char/hw_random/timeriomem-rng.c            |  190 ++-
 drivers/crypto/Kconfig                             |   18 +-
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/atmel-aes.c                         |  471 +++++--
 drivers/crypto/atmel-sha-regs.h                    |    7 +-
 drivers/crypto/atmel-sha.c                         |  586 +++++++--
 drivers/crypto/atmel-tdes-regs.h                   |    2 +
 drivers/crypto/atmel-tdes.c                        |  394 +++++-
 drivers/crypto/bfin_crc.c                          |    6 +-
 drivers/crypto/caam/Kconfig                        |    2 +-
 drivers/crypto/caam/caamalg.c                      |    6 +
 drivers/crypto/caam/caamhash.c                     |    4 +-
 drivers/crypto/caam/ctrl.c                         |    3 +
 drivers/crypto/caam/error.c                        |   10 +-
 drivers/crypto/caam/intern.h                       |    1 +
 drivers/crypto/caam/jr.c                           |    4 +
 drivers/crypto/caam/key_gen.c                      |    2 +-
 drivers/crypto/caam/key_gen.h                      |    2 +-
 drivers/crypto/caam/regs.h                         |    4 +-
 drivers/crypto/omap-aes.c                          |   15 +-
 drivers/crypto/omap-sham.c                         |   15 +-
 drivers/crypto/picoxcell_crypto.c                  |    4 +-
 drivers/crypto/sahara.c                            | 1070 +++++++++++++++
 drivers/crypto/ux500/hash/hash_core.c              |    6 +-
 include/crypto/sha.h                               |    5 +
 include/linux/platform_data/atmel-aes.h            |   22 -
 include/linux/platform_data/crypto-atmel.h         |   22 +
 include/linux/timeriomem-rng.h                     |    5 -
 net/xfrm/xfrm_algo.c                               |   13 +
 88 files changed, 13036 insertions(+), 1352 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

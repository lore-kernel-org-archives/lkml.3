Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3GEJwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:52:50 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:46763 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756596Ab3GEJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:52:48 -0400
Date: Fri, 5 Jul 2013 19:52:40 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.11
Message-ID: <20130705095240.GA22111@gondor.apana.org.au>
References: <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130502014703.GA2033@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502014703.GA2033@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.11:

* Do not idle omap device between crypto operations in one session.
* Added sha224/sha384 shims for SSSE3.
* More optimisations for camellia-aesni-avx2.
* Removed defunct blowfish/twofish AVX2 implementations.
* Added unaligned buffer self-tests.
* Added PCLMULQDQ optimisation for CRCT10DIF.
* Added support for Freescale's DCP co-processor
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andrei Varvara (8):
      crypto: caam - fix SEQ IN PTR command when RTO or PRE bit is set
      crypto: caam - Fix STORE command to support overwriting Shared Descriptor's memory
      crypto: caam - Add MATH command to support shld function
      crypto: caam - Add new macros for building extended SEC descriptors (> 64 words)
      crypto: caam - Add defines for overwriting Descriptor's memory
      crypto: caam - Add defines for CAAM commands
      crypto: caam - Add define for Adjust Output Frame Length in PDB
      crypto: caam - add missing flag for the LOAD/STORE commands

Arnd Bergmann (1):
      hwrng: bcm2835 - fix MODULE_LICENSE tag

Herbert Xu (2):
      crypto: crct10dif - Use PTR_RET
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto

Jingoo Han (6):
      hwrng: atmel - remove unnecessary platform_set_drvdata()
      hwrng: bcm63xx - remove unnecessary platform_set_drvdata()
      hwrng: timeriomem - remove unnecessary platform_set_drvdata()
      hwrng: tx4939 - remove unnecessary platform_set_drvdata()
      hwrng: use platform_{get,set}_drvdata()
      crypto: picoxcell - replace strict_strtoul() with kstrtoul()

Joel A Fernandes (1):
      crypto: omap-aes - Don't idle/start AES device between Encrypt operations

Jussi Kivilinna (10):
      crypto: sha512_generic - set cra_driver_name
      crypto: sha512_ssse3 - add sha384 support
      crypto: sha256_ssse3 - add sha224 support
      crypto: camellia-aesni-avx2 - tune assembly code for more performance
      Revert "crypto: blowfish - add AVX2/x86_64 implementation of blowfish cipher"
      Revert "crypto: twofish - add AVX2/x86_64 assembler implementation of twofish cipher"
      crypto: testmgr - check that entries in alg_test_descs are in correct order
      crypto: testmgr - test skciphers with unaligned buffers
      crypto: testmgr - test AEADs with unaligned buffers
      crypto: testmgr - test hash implementations with unaligned buffers

Lars-Peter Clausen (1):
      crypto: hifn_795x - Pass correct pointer to free_irq()

Laurent Navet (1):
      drivers: crypto: use devm_ioremap_resource()

Linus Walleij (1):
      hwrng: nomadik - use clk_prepare_enable()

Paul Bolle (1):
      crypto: sahara - remove dependency on EXPERIMENTAL

Ruchika Gupta (1):
      crypto: caam - FIX RNG init for RNG greater than equal to 4

Sachin Kamat (6):
      crypto: mv_cesa: Remove redundant platform_set_drvdata()
      crypto: s5p-sss: Remove redundant platform_set_drvdata()
      crypto: dcp - Remove redundant platform_set_drvdata()
      crypto: dcp - Use devm_* APIs
      crypto: dcp - Use NULL instead of 0
      crypto: dcp - Staticize local symbols

Thomas Meyer (1):
      crypto: ux500 - Cocci spatch "resource_size.spatch"

Tim Chen (4):
      crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework
      crypto: crct10dif - Accelerated CRC T10 DIF computation with PCLMULQDQ instruction
      crypto: crct10dif - Glue code to cast accelerated CRCT10DIF assembly as a crypto transform
      crypto: crct10dif - Simple correctness and speed test for CRCT10DIF hash

Tobias Rauter (1):
      crypto: dcp - Added support for Freescale's DCP co-processor

 arch/arm/boot/dts/imx28.dtsi                 |    2 +-
 arch/x86/crypto/Makefile                     |    8 +-
 arch/x86/crypto/blowfish-avx2-asm_64.S       |  449 -------------
 arch/x86/crypto/blowfish_avx2_glue.c         |  585 -----------------
 arch/x86/crypto/blowfish_glue.c              |   32 +-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  160 +++--
 arch/x86/crypto/crct10dif-pcl-asm_64.S       |  643 ++++++++++++++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c      |  151 +++++
 arch/x86/crypto/sha256_ssse3_glue.c          |   57 ++-
 arch/x86/crypto/sha512_ssse3_glue.c          |   58 ++-
 arch/x86/crypto/twofish-avx2-asm_64.S        |  600 -----------------
 arch/x86/crypto/twofish_avx2_glue.c          |  584 ----------------
 arch/x86/crypto/twofish_avx_glue.c           |   14 +-
 arch/x86/include/asm/crypto/blowfish.h       |   43 --
 arch/x86/include/asm/crypto/twofish.h        |   18 -
 crypto/Kconfig                               |   63 +--
 crypto/Makefile                              |    1 +
 crypto/crct10dif.c                           |  178 +++++
 crypto/sha512_generic.c                      |    2 +
 crypto/tcrypt.c                              |    8 +
 crypto/testmgr.c                             |  176 ++++-
 crypto/testmgr.h                             |   33 +
 drivers/char/hw_random/atmel-rng.c           |    2 -
 drivers/char/hw_random/bcm2835-rng.c         |    2 +-
 drivers/char/hw_random/bcm63xx-rng.c         |    2 -
 drivers/char/hw_random/n2-drv.c              |    6 +-
 drivers/char/hw_random/nomadik-rng.c         |    2 +-
 drivers/char/hw_random/octeon-rng.c          |    4 +-
 drivers/char/hw_random/omap-rng.c            |    6 +-
 drivers/char/hw_random/timeriomem-rng.c      |    2 -
 drivers/char/hw_random/tx4939-rng.c          |    1 -
 drivers/crypto/Kconfig                       |   12 +-
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/caam/ctrl.c                   |   10 +-
 drivers/crypto/caam/desc.h                   |   22 +-
 drivers/crypto/caam/desc_constr.h            |   81 +++-
 drivers/crypto/caam/pdb.h                    |    1 +
 drivers/crypto/caam/regs.h                   |   42 ++-
 drivers/crypto/dcp.c                         |  912 ++++++++++++++++++++++++++
 drivers/crypto/hifn_795x.c                   |    4 +-
 drivers/crypto/mv_cesa.c                     |    1 -
 drivers/crypto/omap-aes.c                    |   36 +-
 drivers/crypto/omap-sham.c                   |    7 +-
 drivers/crypto/picoxcell_crypto.c            |    2 +-
 drivers/crypto/s5p-sss.c                     |    2 -
 drivers/crypto/ux500/cryp/cryp_core.c        |    2 +-
 include/linux/crc-t10dif.h                   |    4 +
 lib/Kconfig                                  |    2 +
 lib/crc-t10dif.c                             |   73 +--
 49 files changed, 2542 insertions(+), 2564 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

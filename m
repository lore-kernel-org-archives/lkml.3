Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab3IGDzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:55:55 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:34846 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750847Ab3IGDzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:55:52 -0400
Date: Sat, 7 Sep 2013 13:55:44 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.12
Message-ID: <20130907035544.GA22658@gondor.apana.org.au>
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
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130223023331.GA11002@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.12:

* Added MODULE_SOFTDEP to allow pre-loading of modules.
* Reinstated crct10dif driver using the module softdep feature.
* Allow via rng driver to be auto-loaded.

* Split large input data when necessary in nx.
* Handle zero length messages correctly for GCM/XCBC in nx.
* Handle SHA-2 chunks bigger than block size properly in nx.

* Handle unaligned lengths in omap-aes.
* Added SHA384/SHA512 to omap-sham.
* Added OMAP5/AM43XX SHAM support.
* Added OMAP4 TRNG support.

* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alex Porosanu (2):
      crypto: caam - replace xstr macro with __stringify
      crypto: caam - add option for enabling DEBUG mode

Andi Kleen (1):
      crypto: make tables used from assembler __visible

Andreas Robinson (1):
      modules: add support for soft module dependencies

Ben Hutchings (1):
      hwrng: via - Add MODULE_DEVICE_TABLE

Chen Gang (1):
      padata - share code between CPU_ONLINE and CPU_DOWN_FAILED, same to CPU_DOWN_PREPARE and CPU_UP_CANCELED

Cristian Stoica (1):
      crypto: testmgr - remove double execution of the same test suite

Dan Carpenter (2):
      crypto: sahara - checking the wrong variable
      crypto: tegra-aes - bitwise vs logical and

Fabio Estevam (1):
      hwrng: mxc-rnga - Check the return value from clk_prepare_enable()

Fionnuala Gunter (3):
      crypto: nx - saves chaining value from co-processor
      crypto: nx - fix limits to sg lists for AES-XCBC
      crypto: nx - fix limits to sg lists for AES-CCM

Herbert Xu (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
      Reinstate "crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework"

Jan-Simon Möller (1):
      crypto: fcrypt - Fix bitoperation for compilation with clang

Jingoo Han (3):
      hwrng: pixocel - Staticize 'rng_dev'
      crypto: sahara - Staticize local symbol
      crypto: crypto4xx - Staticize local symbols

Joe Perches (1):
      crypto: ux500 - Fix logging, make arrays const, neatening

Joel Fernandes (14):
      crypto: scatterwalk - Add support for calculating number of SG elements
      crypto: omap-aes - Add useful debug macros
      crypto: omap-aes - Populate number of SG elements
      crypto: omap-aes - Simplify DMA usage by using direct SGs
      crypto: omap-aes - Sync SG before DMA operation
      crypto: omap-aes - Remove previously used intermediate buffers
      crypto: omap-aes - Add IRQ info and helper macros
      crypto: omap-aes - PIO mode: Add IRQ handler and walk SGs
      crypto: omap-aes - PIO mode: platform data for OMAP4/AM437x and trigger
      crypto: omap-aes - Switch to PIO mode during probe
      crypto: omap-aes - Add support for cases of unaligned lengths
      crypto: omap-aes - Convert kzalloc to devm_kzalloc
      crypto: omap-aes - Convert request_irq to devm_request_irq
      crypto: omap-aes - Kconfig: Add build support for AM437x

John Haxby (1):
      crypto: xor - Check for osxsave as well as avx in crypto/xor

Julia Lawall (3):
      hwrng: tx4939 - simplify use of devm_ioremap_resource
      crypto: camellia-x86-64 - replace commas by semicolons and adjust code alignment
      crypto: camellia_generic - replace commas by semicolons and adjust code alignment

Lokesh Vutla (12):
      crypto: omap-sham - Add SHA384 and SHA512 Support
      crypto: omap-sham - Add OMAP5/AM43XX SHAM Support
      crypto: omap-sham - Convert to devm_request_irq()
      crypto: omap-sham - Convert to devm_kzalloc()
      hwrng: omap - Use module_platform_driver macro
      hwrng: omap - Convert to devm_kzalloc()
      hwrng: omap - Remove duplicated function call
      hwrng: omap - Add device tree support
      ARM: OMAP2+: Only manually add hwmod data when DT not used.
      hwrng: omap - Add OMAP4 TRNG support
      crypto: omap-sham - Enable Polling mode if DMA fails
      crypto: omap-sham - correct dma burst size

Marcelo Cerri (11):
      crypto: nx - fix physical addresses added to sg lists
      crypto: nx - fix limits to sg lists for SHA-2
      crypto: nx - fix concurrency issue
      crypto: nx - add offset to nx_build_sg_lists()
      crypto: nx - fix limits to sg lists for AES-ECB
      crypto: nx - fix limits to sg lists for AES-CBC
      crypto: nx - fix limits to sg lists for AES-CTR
      crypto: nx - fix limits to sg lists for AES-GCM
      crypto: nx - fix XCBC for zero length messages
      crypto: nx - fix GCM for zero length messages
      crypto: nx - fix SHA-2 for chunks bigger than block size

Olof Johansson (1):
      hwrng: omap - reorder OMAP TRNG driver code

Richard Weinberger (1):
      padata - Register hotcpu notifier after initialization

Ruchika Gupta (2):
      crypto: caam - RNG instantiation by directly programming DECO
      crypto: caam - Remove unused functions from Job Ring

Vakul Garg (1):
      crypto: caam - Moved macro DESC_JOB_IO_LEN to desc_constr.h

jmlatten@linux.vnet.ibm.com (1):
      crypto: nx - fix nx-aes-gcm verification

 arch/arm/mach-omap2/devices.c           |    2 +-
 arch/x86/crypto/Makefile                |    2 +
 arch/x86/crypto/camellia_glue.c         |   64 +--
 arch/x86/crypto/crct10dif-pcl-asm_64.S  |  643 +++++++++++++++++++++++++++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c |  151 ++++++++
 arch/x86/include/asm/xor_avx.h          |    4 +-
 crypto/Kconfig                          |   19 +
 crypto/Makefile                         |    1 +
 crypto/aes_generic.c                    |    8 +-
 crypto/camellia_generic.c               |   48 +--
 crypto/cast_common.c                    |    8 +-
 crypto/crct10dif.c                      |  178 +++++++++
 crypto/fcrypt.c                         |    2 +-
 crypto/scatterwalk.c                    |   22 ++
 crypto/tcrypt.c                         |    8 +
 crypto/testmgr.c                        |   12 +-
 crypto/testmgr.h                        |   33 ++
 drivers/char/hw_random/Kconfig          |    6 +-
 drivers/char/hw_random/mxc-rnga.c       |    4 +-
 drivers/char/hw_random/omap-rng.c       |  386 +++++++++++++++----
 drivers/char/hw_random/picoxcell-rng.c  |    2 +-
 drivers/char/hw_random/tx4939-rng.c     |    4 +-
 drivers/char/hw_random/via-rng.c        |    7 +
 drivers/crypto/Kconfig                  |   13 +-
 drivers/crypto/amcc/crypto4xx_alg.c     |   15 +-
 drivers/crypto/caam/Kconfig             |    8 +
 drivers/crypto/caam/Makefile            |    3 +
 drivers/crypto/caam/caamalg.c           |   80 ++--
 drivers/crypto/caam/caamhash.c          |   70 ++--
 drivers/crypto/caam/ctrl.c              |   77 ++--
 drivers/crypto/caam/desc_constr.h       |    1 +
 drivers/crypto/caam/intern.h            |    5 -
 drivers/crypto/caam/jr.c                |   67 ----
 drivers/crypto/caam/jr.h                |    2 -
 drivers/crypto/caam/key_gen.c           |    6 +-
 drivers/crypto/caam/regs.h              |   12 +-
 drivers/crypto/nx/nx-aes-cbc.c          |   57 ++-
 drivers/crypto/nx/nx-aes-ccm.c          |  283 ++++++++++----
 drivers/crypto/nx/nx-aes-ctr.c          |   52 ++-
 drivers/crypto/nx/nx-aes-ecb.c          |   50 ++-
 drivers/crypto/nx/nx-aes-gcm.c          |  296 ++++++++++----
 drivers/crypto/nx/nx-aes-xcbc.c         |  205 +++++++---
 drivers/crypto/nx/nx-sha256.c           |  124 +++---
 drivers/crypto/nx/nx-sha512.c           |  131 ++++---
 drivers/crypto/nx/nx.c                  |   35 +-
 drivers/crypto/nx/nx.h                  |    3 +-
 drivers/crypto/omap-aes.c               |  468 ++++++++++++----------
 drivers/crypto/omap-sham.c              |  382 ++++++++++++++----
 drivers/crypto/sahara.c                 |    4 +-
 drivers/crypto/tegra-aes.c              |    6 +-
 drivers/crypto/ux500/hash/hash_core.c   |  586 ++++++++++++++--------------
 include/crypto/scatterwalk.h            |    2 +
 include/linux/crc-t10dif.h              |    4 +
 include/linux/module.h                  |    5 +
 kernel/padata.c                         |   32 +-
 lib/Kconfig                             |    2 +
 lib/crc-t10dif.c                        |   74 ++--
 57 files changed, 3410 insertions(+), 1364 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

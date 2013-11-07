Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3KGIBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:01:47 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:46156 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797Ab3KGIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:01:37 -0500
Date: Thu, 7 Nov 2013 16:01:32 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.13
Message-ID: <20131107080131.GA32307@gondor.apana.org.au>
References: <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130907035544.GA22658@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.13:

* Made x86 ablk_helper generic for ARM.
* Phase out chainiv in favour of eseqiv (affects IPsec).
* Fixed aes-cbc IV corruption on s390.
* Added constant-time crypto_memneq which replaces memcmp.

* Fixed aes-ctr in omap-aes.
* Added OMAP3 ROM RNG support.
* Add PRNG support for MSM SoC's
* Add and use Job Ring API in caam.

* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git



Alex Porosanu (7):
      crypto: caam - fix RNG state handle instantiation descriptor
      crypto: caam - fix hash, alg and rng registration if CAAM driver not initialized
      crypto: caam - fix RNG4 instantiation
      crypto: caam - split RNG4 instantiation function
      crypto: caam - uninstantiate RNG state handle 0 if instantiated by caam driver
      crypto: caam - fix RNG4 AAI defines
      crypto: caam - enable instantiation of all RNG4 state handles

Ard Biesheuvel (2):
      crypto: create generic version of ablk_helper
      crypto: move x86 to the generic version of ablk_helper

Ben Hutchings (1):
      hwrng: via-rng - Mark device ID table as __maybe_unused

Fabio Estevam (4):
      crypto: dcp - Use devm_ioremap_resource()
      crypto: dcp - Use devm_request_irq()
      crypto: dcp - Fix the path for releasing the resources
      crypto: dcp - Check the return value from devm_ioremap_resource()

Herbert Xu (2):
      crypto: skcipher - Use eseqiv even on UP machines
      crypto: s390 - Fix aes-cbc IV corruption

James Yonan (1):
      crypto: crypto_memneq - add equality testing of memory regions w/o timing leaks

Joel Fernandes (1):
      crypto: omap-aes - Fix CTR mode counter length

Joni Lapilainen (1):
      crypto: omap-sham - Add missing modalias

Jussi Kivilinna (2):
      crypto: sha256_ssse3 - use correct module alias for sha224
      crypto: x86 - restore avx2_supported check

Linus Walleij (1):
      crypto: tegra - use kernel entropy instead of ad-hoc

Mathias Krause (6):
      crypto: authenc - Export key parsing helper function
      crypto: authencesn - Simplify key parsing
      crypto: ixp4xx - Simplify and harden key parsing
      crypto: picoxcell - Simplify and harden key parsing
      crypto: talitos - Simplify key parsing
      padata: make the sequence counter an atomic_t

Michael Ellerman (2):
      hwrng: pseries - Use KBUILD_MODNAME in pseries-rng.c
      hwrng: pseries - Return errors to upper levels in pseries-rng.c

Michael Opdenacker (1):
      crypto: mv_cesa: remove deprecated IRQF_DISABLED

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Oliver Neukum (1):
      crypto: sha256_ssse3 - also test for BMI2

Pali Rohár (1):
      hwrng: OMAP3 ROM Random Number Generator support

Ruchika Gupta (3):
      crypto: caam - Add Platform driver for Job Ring
      crypto: caam - Add API's to allocate/free Job Rings
      crypto: caam - Modify the interface layers to use JR API's

Sachin Kamat (7):
      crypto: mv_cesa - Staticize local symbols
      crypto: omap-aes - Staticize local symbols
      crypto: tegra-aes - Staticize tegra_aes_cra_exit
      crypto: tegra-aes - Fix NULL pointer dereference
      crypto: tegra-aes - Use devm_clk_get
      crypto: sahara - Remove redundant of_match_ptr
      crypto: mv_cesa - Remove redundant of_match_ptr

Stanimir Varbanov (2):
      ARM: DT: msm: Add Qualcomm's PRNG driver binding document
      hwrng: msm - Add PRNG support for MSM SoC's

Stephen Warren (1):
      ARM: tegra: remove tegra_chip_uid()

Yashpal Dutta (1):
      crypto: caam - map src buffer before access

kbuild test robot (1):
      crypto: ablk_helper - Replace memcpy with struct assignment

 .../devicetree/bindings/rng/qcom,prng.txt          |   17 +
 arch/arm/mach-tegra/fuse.c                         |   10 -
 arch/s390/crypto/aes_s390.c                        |   19 +-
 arch/x86/crypto/Makefile                           |    3 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    2 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |    2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |    2 +-
 arch/x86/crypto/cast5_avx_glue.c                   |    2 +-
 arch/x86/crypto/cast6_avx_glue.c                   |    2 +-
 arch/x86/crypto/serpent_avx2_glue.c                |    2 +-
 arch/x86/crypto/serpent_avx_glue.c                 |    2 +-
 arch/x86/crypto/serpent_sse2_glue.c                |    2 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |    4 +-
 arch/x86/crypto/twofish_avx_glue.c                 |    2 +-
 arch/x86/include/asm/simd.h                        |   11 +
 crypto/Kconfig                                     |   23 +-
 crypto/Makefile                                    |    8 +-
 {arch/x86/crypto => crypto}/ablk_helper.c          |   13 +-
 crypto/ablkcipher.c                                |   21 +-
 crypto/ansi_cprng.c                                |    4 +-
 crypto/asymmetric_keys/rsa.c                       |    5 +-
 crypto/authenc.c                                   |   54 ++-
 crypto/authencesn.c                                |   34 +--
 crypto/ccm.c                                       |    4 +-
 crypto/gcm.c                                       |    2 +-
 crypto/memneq.c                                    |  138 +++++++
 drivers/char/hw_random/Kconfig                     |   25 ++
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/msm-rng.c                   |  197 +++++++++
 drivers/char/hw_random/omap3-rom-rng.c             |  141 +++++++
 drivers/char/hw_random/pseries-rng.c               |   19 +-
 drivers/char/hw_random/via-rng.c                   |    2 +-
 drivers/crypto/caam/Kconfig                        |   25 +-
 drivers/crypto/caam/Makefile                       |    4 +-
 drivers/crypto/caam/caamalg.c                      |   83 +---
 drivers/crypto/caam/caamhash.c                     |   88 ++---
 drivers/crypto/caam/caamrng.c                      |   29 +-
 drivers/crypto/caam/ctrl.c                         |  418 ++++++++++++++++----
 drivers/crypto/caam/desc.h                         |   17 +-
 drivers/crypto/caam/intern.h                       |   20 +-
 drivers/crypto/caam/jr.c                           |  339 +++++++++++-----
 drivers/crypto/caam/jr.h                           |    5 +-
 drivers/crypto/caam/regs.h                         |   14 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   34 ++-
 drivers/crypto/dcp.c                               |   49 +--
 drivers/crypto/ixp4xx_crypto.c                     |   26 +-
 drivers/crypto/mv_cesa.c                           |   14 +-
 drivers/crypto/omap-aes.c                          |    6 +-
 drivers/crypto/omap-sham.c                         |    1 +
 drivers/crypto/picoxcell_crypto.c                  |   32 +--
 drivers/crypto/sahara.c                            |    2 +-
 drivers/crypto/talitos.c                           |   35 +--
 drivers/crypto/tegra-aes.c                         |   26 +-
 include/asm-generic/simd.h                         |   14 +
 .../include/asm => include}/crypto/ablk_helper.h   |    0
 include/crypto/algapi.h                            |   18 +-
 include/crypto/authenc.h                           |   12 +-
 include/linux/padata.h                             |    3 +-
 kernel/padata.c                                    |    9 +-
 59 files changed, 1454 insertions(+), 643 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

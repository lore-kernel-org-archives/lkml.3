Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaLKMvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:51:36 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:41143 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaLKMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:32 -0500
Date: Thu, 11 Dec 2014 23:51:20 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: Crypto Update for 3.19
Message-ID: <20141211125119.GA12380@gondor.apana.org.au>
References: <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007131826.GA29688@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.19:

* The crypto API is now documented :)
* Disallow arbitrary module loading through crypto API.
* Allow get request with empty driver name through crypto_user.
* Allow speed testing of arbitrary hash functions.
* Add caam support for ctr(aes), gcm(aes) and their derivatives.
* nx now supports concurrent hashing properly.
* Add sahara support for SHA1/256.
* Add ARM64 version of CRC32.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

 
Boris Brezillon (4):
      hwrng: atmel - use clk_prepapre_enable/_disable_unprepare
      hwrng: atmel - add DT support
      hwrng: atmel - Add TRNG DT binding doc
      ARM: at91/dt: add trng node to at91sam9g45

Bruce Allan (4):
      crypto: qat - fix bad unlock balance
      crypto: qat - cleanup coccicheck warning - NULL check before freeing functions
      crypto: qat - cleanup unnecessary break checkpatch warning
      crypto: qat - misspelling typo - "reseting" should be "resetting"

Catalin Vasile (5):
      crypto: caam - add support for ctr(aes)
      crypto: caam - add support for rfc3686(ctr(aes))
      crypto: caam - add support for rfc3686 with authenc md5, sha1 and sha2
      crypto: caam - add support for givencrypt cbc(aes) and rfc3686(ctr(aes))
      crypto: caam - add support for givencrypt cbc(des) and cbc(des3_ede)

Cristian Stoica (1):
      crypto: caam - fix error reporting

Dan Carpenter (1):
      crypto: sha-mb - remove a bogus NULL check

Daniel Borkmann (1):
      crypto: algif - add and use sock_kzfree_s() instead of memzero_explicit()

Herbert Xu (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
      crypto: user - Allow get request with empty driver name
      crypto: algif_skcipher - Fixed blocking recvmsg
      crypto: tcrypt - Allow speed testing of arbitrary hash functions

Johannes Berg (1):
      crypto: bfin_crc - don't include linux/unaligned/access_ok.h

Julia Lawall (4):
      crypto: sparc - replace memset by memzero_explicit
      crypto: sha - replace memset by memzero_explicit
      crypto: powerpc - replace memset by memzero_explicit
      crypto: arm - replace memset by memzero_explicit

Kees Cook (2):
      crypto: prefix module autoloading with "crypto-"
      crypto: include crypto- module prefix in template

Leonidas S. Barbosa (8):
      crypto: nx - Moving NX-AES-CBC to be processed logic
      crypto: nx - Moving NX-AES-CCM to be processed logic and sg_list bounds
      crypto: nx - Moving limit and bound logic in CTR and fix IV vector
      crypto: nx - Moving NX-AES-ECB to be processed logic
      crypto: nx - Moving NX-AES-GCM to be processed logic
      crypto: nx - Moving NX-AES-XCBC to be processed logic
      crypto: nx - Fix SHA concurrence issue and sg limit bounds
      crypto: nx - Fixing the limit number of bytes to be processed

Masanari Iida (1):
      crypto: testmgr - Remove unnecessary KERN_INFO from testmgr.c

Nickolaus Woodruff (1):
      crypto: drbg - use memzero_explicit() for clearing sensitive data

Pranith Kumar (1):
      crypto: caam - Remove unnecessary smp_read_barrier_depends()

Rickard Strandqvist (1):
      hwrng: core - Changed from using strncat to strlcat

Steffen Trumtrar (4):
      crypto: sahara - fix spinlock initialization
      crypto: sahara - add support for i.MX53
      crypto: sahara - replace tasklets with kthread
      crypto: sahara - add support for SHA1/256

Stephan Mueller (22):
      crypto: drbg - use crypto_inc
      crypto: drbg - add MODULE_ALIAS for all DRBG types
      crypto: algif - zeroize message digest buffer
      crypto: algif - zeroize IV buffer
      crypto: doc - crypto API high level spec
      crypto: doc - compile crypto API spec
      crypto: doc - userspace interface spec
      crypto: doc - RNG API documentation
      crypto: doc - hash data structures
      crypto: doc - AHASH API documentation
      crypto: doc - SHASH API documentation
      crypto: doc - cipher data structures
      crypto: doc - ABLKCIPHER API documentation
      crypto: doc - AEAD API documentation
      crypto: doc - BLKCIPHER API documentation
      crypto: doc - CIPHER API documentation
      crypto: doc - HASH API documentation
      crypto: doc - document uncovered member variables
      crypto: user - add MODULE_ALIAS
      crypto: drbg - use MODULE_ALIAS_CRYPTO
      crypto: algif_skcipher - initialize upon init request
      crypto: af_alg - add user space interface for AEAD

Struk, Tadeusz (3):
      crypto: qat - Use memzero_explicit
      crytpo: qat - Fix 64 bytes requests
      crypto: algif_skcipher - removed unneeded code

Tadeusz Struk (2):
      crypto: qat - Move BAR definitions to device specific module
      crypto: qat - fix problem with coalescing enable logic

Tudor Ambarus (4):
      crypto: caam - add support for gcm(aes)
      crypto: caam - add support for rfc4106(gcm(aes))
      crypto: caam - fix output sequence contiguity check
      crypto: caam - add support for rfc4543(gcm(aes))

Ulf Hansson (2):
      crypto: ux500/cryp - Silence compiler warning for !CONFIG_PM
      crypto: ux500/hash - Silence compiler warning for !CONFIG_PM

Valentin Rothberg (1):
      crypto: aesni - remove unnecessary #define

Yazen Ghannam (1):
      crypto: crc32 - Add ARM64 CRC32 hw accelerated module

 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/crypto-API.tmpl              | 1253 ++++++++++
 Documentation/crypto/crypto-API-userspace.txt      |  205 ++
 .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |    2 +-
 .../devicetree/bindings/hwrng/atmel-trng.txt       |   16 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |    7 +
 arch/arm/crypto/aes_glue.c                         |    4 +-
 arch/arm/crypto/sha1_glue.c                        |    2 +-
 arch/arm/crypto/sha1_neon_glue.c                   |    2 +-
 arch/arm/crypto/sha512_neon_glue.c                 |    6 +-
 arch/arm64/crypto/Kconfig                          |    4 +
 arch/arm64/crypto/Makefile                         |    4 +
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    2 +-
 arch/arm64/crypto/aes-glue.c                       |    8 +-
 arch/arm64/crypto/crc32-arm64.c                    |  274 +++
 arch/powerpc/crypto/sha1.c                         |    4 +-
 arch/s390/crypto/aes_s390.c                        |    2 +-
 arch/s390/crypto/des_s390.c                        |    4 +-
 arch/s390/crypto/ghash_s390.c                      |    2 +-
 arch/s390/crypto/sha1_s390.c                       |    2 +-
 arch/s390/crypto/sha256_s390.c                     |    4 +-
 arch/s390/crypto/sha512_s390.c                     |    4 +-
 arch/sparc/crypto/aes_glue.c                       |    2 +-
 arch/sparc/crypto/camellia_glue.c                  |    2 +-
 arch/sparc/crypto/crc32c_glue.c                    |    2 +-
 arch/sparc/crypto/des_glue.c                       |    2 +-
 arch/sparc/crypto/md5_glue.c                       |    2 +-
 arch/sparc/crypto/sha1_glue.c                      |    2 +-
 arch/sparc/crypto/sha256_glue.c                    |    6 +-
 arch/sparc/crypto/sha512_glue.c                    |    6 +-
 arch/x86/crypto/aes_glue.c                         |    4 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   10 +-
 arch/x86/crypto/blowfish_glue.c                    |    4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |    4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |    4 +-
 arch/x86/crypto/camellia_glue.c                    |    4 +-
 arch/x86/crypto/cast5_avx_glue.c                   |    2 +-
 arch/x86/crypto/cast6_avx_glue.c                   |    2 +-
 arch/x86/crypto/crc32-pclmul_glue.c                |    4 +-
 arch/x86/crypto/crc32c-intel_glue.c                |    4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |    4 +-
 arch/x86/crypto/des3_ede_glue.c                    |    8 +-
 arch/x86/crypto/fpu.c                              |    3 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    2 +-
 arch/x86/crypto/salsa20_glue.c                     |    4 +-
 arch/x86/crypto/serpent_avx2_glue.c                |    4 +-
 arch/x86/crypto/serpent_avx_glue.c                 |    2 +-
 arch/x86/crypto/serpent_sse2_glue.c                |    2 +-
 arch/x86/crypto/sha-mb/sha1_mb.c                   |    3 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |    2 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |    6 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |    6 +-
 arch/x86/crypto/twofish_avx_glue.c                 |    2 +-
 arch/x86/crypto/twofish_glue.c                     |    4 +-
 arch/x86/crypto/twofish_glue_3way.c                |    4 +-
 crypto/842.c                                       |    1 +
 crypto/aes_generic.c                               |    2 +-
 crypto/af_alg.c                                    |    6 +
 crypto/algapi.c                                    |    4 +-
 crypto/algif_hash.c                                |    4 +-
 crypto/algif_skcipher.c                            |   15 +-
 crypto/ansi_cprng.c                                |    2 +-
 crypto/anubis.c                                    |    1 +
 crypto/api.c                                       |    4 +-
 crypto/arc4.c                                      |    1 +
 crypto/authenc.c                                   |    1 +
 crypto/authencesn.c                                |    1 +
 crypto/blowfish_generic.c                          |    2 +-
 crypto/camellia_generic.c                          |    2 +-
 crypto/cast5_generic.c                             |    2 +-
 crypto/cast6_generic.c                             |    2 +-
 crypto/cbc.c                                       |    1 +
 crypto/ccm.c                                       |    5 +-
 crypto/chainiv.c                                   |    1 +
 crypto/cmac.c                                      |    1 +
 crypto/crc32.c                                     |    1 +
 crypto/crc32c_generic.c                            |    2 +-
 crypto/crct10dif_generic.c                         |    2 +-
 crypto/cryptd.c                                    |    1 +
 crypto/crypto_null.c                               |    6 +-
 crypto/crypto_user.c                               |    6 +-
 crypto/ctr.c                                       |    3 +-
 crypto/cts.c                                       |    1 +
 crypto/deflate.c                                   |    2 +-
 crypto/des_generic.c                               |    2 +-
 crypto/drbg.c                                      |  127 +-
 crypto/ecb.c                                       |    1 +
 crypto/eseqiv.c                                    |    1 +
 crypto/fcrypt.c                                    |    1 +
 crypto/gcm.c                                       |    7 +-
 crypto/ghash-generic.c                             |    2 +-
 crypto/hmac.c                                      |    1 +
 crypto/khazad.c                                    |    1 +
 crypto/krng.c                                      |    2 +-
 crypto/lrw.c                                       |    1 +
 crypto/lz4.c                                       |    1 +
 crypto/lz4hc.c                                     |    1 +
 crypto/lzo.c                                       |    1 +
 crypto/mcryptd.c                                   |    1 +
 crypto/md4.c                                       |    2 +-
 crypto/md5.c                                       |    1 +
 crypto/michael_mic.c                               |    1 +
 crypto/pcbc.c                                      |    1 +
 crypto/pcrypt.c                                    |    1 +
 crypto/rmd128.c                                    |    1 +
 crypto/rmd160.c                                    |    1 +
 crypto/rmd256.c                                    |    1 +
 crypto/rmd320.c                                    |    1 +
 crypto/salsa20_generic.c                           |    2 +-
 crypto/seed.c                                      |    1 +
 crypto/seqiv.c                                     |    1 +
 crypto/serpent_generic.c                           |    4 +-
 crypto/sha1_generic.c                              |    2 +-
 crypto/sha256_generic.c                            |    4 +-
 crypto/sha512_generic.c                            |    4 +-
 crypto/tcrypt.c                                    |   32 +-
 crypto/tea.c                                       |    4 +-
 crypto/testmgr.c                                   |    3 +-
 crypto/tgr192.c                                    |    4 +-
 crypto/twofish_generic.c                           |    2 +-
 crypto/vmac.c                                      |    1 +
 crypto/wp512.c                                     |    4 +-
 crypto/xcbc.c                                      |    1 +
 crypto/xts.c                                       |    1 +
 crypto/zlib.c                                      |    1 +
 drivers/char/hw_random/Kconfig                     |    2 +-
 drivers/char/hw_random/atmel-rng.c                 |   15 +-
 drivers/char/hw_random/core.c                      |   12 +-
 drivers/crypto/bfin_crc.c                          |    2 +-
 drivers/crypto/caam/caamalg.c                      | 2412 +++++++++++++++++---
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/desc_constr.h                  |    2 +
 drivers/crypto/caam/error.c                        |   25 +-
 drivers/crypto/caam/jr.c                           |    3 -
 drivers/crypto/nx/nx-aes-cbc.c                     |   12 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |   61 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |   13 +-
 drivers/crypto/nx/nx-aes-ecb.c                     |   12 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |   66 +-
 drivers/crypto/nx/nx-aes-xcbc.c                    |   81 +-
 drivers/crypto/nx/nx-sha256.c                      |  208 +-
 drivers/crypto/nx/nx-sha512.c                      |  222 +-
 drivers/crypto/nx/nx.c                             |  127 +-
 drivers/crypto/nx/nx.h                             |    8 +-
 drivers/crypto/padlock-aes.c                       |    2 +-
 drivers/crypto/padlock-sha.c                       |    8 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    2 -
 drivers/crypto/qat/qat_common/adf_aer.c            |    2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    3 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    6 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   15 +-
 .../qat/qat_common/adf_transport_access_macros.h   |    9 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   37 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |    3 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |   12 +-
 drivers/crypto/sahara.c                            |  794 ++++++-
 drivers/crypto/ux500/cryp/cryp_core.c              |    6 +-
 drivers/crypto/ux500/hash/hash_core.c              |   10 +-
 drivers/s390/crypto/ap_bus.c                       |    3 +-
 include/crypto/hash.h                              |  492 ++++
 include/crypto/if_alg.h                            |    1 +
 include/crypto/rng.h                               |   80 +
 include/linux/crypto.h                             | 1112 ++++++++-
 include/net/sock.h                                 |    1 +
 include/uapi/linux/if_alg.h                        |    2 +
 net/core/sock.c                                    |   24 +-
 167 files changed, 7090 insertions(+), 1068 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

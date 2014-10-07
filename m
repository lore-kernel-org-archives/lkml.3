Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaJGNTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:19:19 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:60696 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJGNTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:19:17 -0400
Date: Tue, 7 Oct 2014 21:18:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: Crypto Update for 3.18
Message-ID: <20141007131826.GA29688@gondor.apana.org.au>
References: <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804130339.GA1178@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.18:

* Add multibuffer infrastructure:
 . Add single_task_running scheduler helper, OKed by Peter on lkml.
* Add SHA1 multibuffer implementation for AVX2.
* Reenable "by8" AVX CTR optimisation after fixing counter overflow.
* Add APM X-Gene SoC RNG support.
* SHA256/SHA512 now handles unaligned input correctly.
* Set lz4 decompressed length correctly.
* Fix algif socket buffer allocation failure for 64K page machines.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alex Porosanu (3):
      crypto: caam - disable RNG oscillator maximum frequency check
      crypto: caam - change starting entropy delay value
      crypto: caam - enable raw data instead of von Neumann data

Alexander Gordeev (1):
      crypto: qat - Use pci_enable_msix_exact() instead of pci_enable_msix()

Cristian Stoica (7):
      crypto: testmgr - white space fix-ups on test_aead
      crypto: testmgr - white space removal on __test_hash
      crypto: testmgr - white space removal on __test_skcipher
      crypto: testmgr - delay execution of set-up code
      crypto: testmgr - remove unused function argument
      crypto: caam - remove duplicated sg copy functions
      crypto: caam - fix addressing of struct member

David S. Miller (1):
      crypto: sha - Handle unaligned input data in generic sha256 and sha512.

Feng Kan (3):
      hwrng: xgene - add support for APM X-Gene SoC RNG support
      Documentation: rng: Add X-Gene SoC RNG driver documentation
      arm64: dts: add random number generator dts node to APM X-Gene platform.

Fengguang Wu (2):
      crypto: mcryptd - mcryptd_flist can be static
      crypto: sha-mb - sha1_mb_alg_state can be static

Herbert Xu (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

KOVACS Krisztian (2):
      crypto: lz4,lz4hc - fix decompression
      crypto: testmgr - add test for lz4 and lz4hc

Mathias Krause (3):
      crypto: aesni - fix counter overflow handling in "by8" variant
      crypto: aesni - remove unused defines in "by8" variant
      Revert "crypto: aesni - disable "by8" AVX CTR optimization"

Nitesh Narayan Lal (1):
      crypto: caam - Dynamic allocation of addresses for various memory blocks in CAAM.

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Rasmus Villemoes (1):
      crypto: mv_cesa - Add missing #define

Stephan Mueller (10):
      crypto: drbg - replace int2byte with cpu_to_be
      crypto: drbg - kzfree does not need a check for NULL pointer
      crypto: drbg - remove superflowous checks
      crypto: drbg - remove superflowous memset(0)
      crypto: drbg - use kmalloc instead of kzalloc for V and C
      crypto: drbg - remove unnecessary sanity checks
      crypto: drbg - remove configuration of fixed values
      crypto: drbg - remove unnecessary sanity check for shadow state
      crypto: drbg - fix sparse warning for cpu_to_be[32|64]
      crypto: drbg - fix maximum value checks on 32 bit systems

Sudip Mukherjee (1):
      hwrng: printk replacement

Tadeusz Struk (2):
      crypto: qat - Fix typo in name of tasklet_struct
      crypto: qat - Removed unneeded partial state

Ted Percival (1):
      crypto: mcryptd - Fix typos in CRYPTO_MCRYPTD description

Tim Chen (7):
      crypto: hash - initialize entry len for null input in crypto hash sg list walk
      sched: Add function single_task_running to let a task check if it is the only task running on a cpu
      crypto: sha-mb - multibuffer crypto infrastructure
      crypto: sha-mb - SHA1 multibuffer algorithm data structures
      crypto: sha-mb - SHA1 multibuffer submit and flush routines for AVX2
      crypto: sha-mb - SHA1 multibuffer crypto computation (x8 AVX2)
      crypto: sha-mb - SHA1 multibuffer job manager and glue code

Wei Yongjun (1):
      crypto: qat - Fix return value check in adf_chr_drv_create()

 Documentation/devicetree/bindings/rng/apm,rng.txt  |   17 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   21 +
 arch/x86/crypto/Makefile                           |    1 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |   20 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    4 +-
 arch/x86/crypto/sha-mb/Makefile                    |   11 +
 arch/x86/crypto/sha-mb/sha1_mb.c                   |  935 +++++++++++++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S    |  287 ++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S    |  327 +++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c     |   64 ++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S   |  228 +++++
 arch/x86/crypto/sha-mb/sha1_x8_avx2.S              |  472 ++++++++++
 arch/x86/crypto/sha-mb/sha_mb_ctx.h                |  136 +++
 arch/x86/crypto/sha-mb/sha_mb_mgr.h                |  110 +++
 crypto/Kconfig                                     |   30 +
 crypto/Makefile                                    |    1 +
 crypto/ahash.c                                     |   12 +-
 crypto/algif_skcipher.c                            |    2 +-
 crypto/drbg.c                                      |  130 +--
 crypto/lz4.c                                       |    2 +-
 crypto/lz4hc.c                                     |    2 +-
 crypto/mcryptd.c                                   |  705 ++++++++++++++
 crypto/sha256_generic.c                            |    3 +-
 crypto/sha512_generic.c                            |    3 +-
 crypto/testmgr.c                                   |  966 ++++++++++----------
 crypto/testmgr.h                                   |   66 ++
 drivers/char/hw_random/Kconfig                     |   13 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/amd-rng.c                   |    4 +-
 drivers/char/hw_random/geode-rng.c                 |    4 +-
 drivers/char/hw_random/intel-rng.c                 |   13 +-
 drivers/char/hw_random/pasemi-rng.c                |    2 +-
 drivers/char/hw_random/pseries-rng.c               |    2 +-
 drivers/char/hw_random/via-rng.c                   |    8 +-
 drivers/char/hw_random/xgene-rng.c                 |  423 +++++++++
 drivers/crypto/caam/caamhash.c                     |   28 +-
 drivers/crypto/caam/ctrl.c                         |  138 ++-
 drivers/crypto/caam/intern.h                       |    9 +-
 drivers/crypto/caam/regs.h                         |   51 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   54 --
 drivers/crypto/mv_cesa.h                           |    1 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    2 +-
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   66 +-
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |   14 +-
 include/crypto/drbg.h                              |   19 +-
 include/crypto/internal/hash.h                     |    9 +
 include/crypto/mcryptd.h                           |  112 +++
 include/linux/sched.h                              |    1 +
 kernel/sched/core.c                                |   12 +
 50 files changed, 4706 insertions(+), 837 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

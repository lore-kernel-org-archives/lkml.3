Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaHDNEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:04:05 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41531 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaHDNDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:03:53 -0400
Date: Mon, 4 Aug 2014 21:03:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.17
Message-ID: <20140804130339.GA1178@gondor.apana.org.au>
References: <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605062336.GA14440@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.17:

* Added CTR(AES) optimisation on x86_64 using "by8" AVX.
* Added arm64 support to ccp.
* Added Intel QAT crypto driver.
* Added Qualcomm crypto engine driver.
* Added x86-64 assembly optimisation for 3DES.
* Added CTR(3DES) speed test.
* Moved FIPS panic from module.c so that it only triggers on crypto modules.
* Added SP800-90A Deterministic Random Bit Generator (drbg).
* Added more test vectors for ghash.
* Tweaked self tests to catch partial block bugs.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

 
Ard Biesheuvel (2):
      crypto: testmgr - add 4 more test vectors for GHASH
      crypto: testmgr - use chunks smaller than algo block size in chunk tests

Arnd Bergmann (1):
      crypto: ux500 - make interrupt mode plausible

Chen Gang (1):
      crypto: qce - Let 'DEV_QCE' depend on both HAS_DMA and HAS_IOMEM

Dan Carpenter (2):
      crypto: caam - remove duplicate FIFOST_CONT_MASK define
      crypto: qat - remove an unneeded cast

Eric Dumazet (2):
      crypto: lzo - try kmalloc() before vmalloc()
      crypto: lzo - use kvfree() helper

Fengguang Wu (1):
      crypto: drbg - drbg_exit() can be static

George Spelvin (1):
      crypto: crc32c-pclmul - Shrink K_table to 32-bit words

Herbert Xu (2):
      crypto: qat - Fix build problem with O=
      crypto: drbg - Use Kconfig to ensure at least one RNG option is set

Himangi Saraogi (1):
      crypto: caam - Introduce the use of the managed version of kzalloc

Horia Geanta (12):
      crypto: testmgr - avoid DMA mapping from text, rodata, stack
      crypto: caam - set coherent_dma_mask
      crypto: caam - fix typo in dma_mapping_error
      crypto: caam - fix "failed to check map error" DMA warnings
      crypto: caam - fix DMA unmapping error in hash_digest_key
      crypto: caam - fix DMA direction mismatch in ahash_done_ctx_dst
      crypto: caam - fix DMA direction mismatch in ahash_done_ctx_src
      crypto: caam - fix uninitialized S/G table size in ahash_digest
      crypto: caam - fix uninitialized edesc->dst_dma field
      crypto: caam - fix uninitialized state->buf_dma field
      crypto: caam - set DK (Decrypt Key) bit only for AES accelerator
      crypto: caam - fix DECO RSR polling

Jarod Wilson (2):
      crypto: fips - only panic on bad/missing crypto mod signatures
      crypto: testmgr - add missing spaces to drbg error strings

Jean Delvare (1):
      crypto: drivers - Add 2 missing __exit_p

Jussi Kivilinna (3):
      crypto: tcrypt - add ctr(des3_ede) sync speed test
      crypto: des_3des - add x86-64 assembly implementation
      crypto: des3_ede-x86_64 - fix parse warning

Luca Clementi (1):
      crypto: tcrypt - print cra driver name in tcrypt tests output

Marek Vasut (2):
      crypto: api - Move crypto_yield() to algapi.h
      crypto: skcipher - Don't use __crypto_dequeue_request()

Mark Rustad (1):
      crypto: Resolve shadow warnings

Nitesh Narayan Lal (2):
      crypto: dts - Addition of missing SEC compatibile property in c29x device tree
      crypto: caam - Enabling multiple caam debug support for C29x platform

Pramod Gurav (2):
      crypto: atmel-sha - Switch to managed version of kzalloc
      crypto: atmel-tdes - Switch to managed version of kzalloc

Ruchika Gupta (5):
      crypto: caam - Correct definition of registers in memory map
      crypto: caam - Configuration for platforms with virtualization enabled in CAAM
      crypto: caam - Add definition of rd/wr_reg64 for little endian platform
      crypto: caam - Correct the dma mapping for sg table
      crypto: caam - Check for CAAM block presence before registering with crypto layer

Stanimir Varbanov (5):
      crypto: qce - Qualcomm crypto engine driver
      crypto: qce - Build Qualcomm crypto driver
      ARM: DT: qcom: Add Qualcomm crypto driver binding document
      crypto: qce - fix sparse warnings
      crypto: qce - add dependancy to Kconfig

Stephan Mueller (16):
      crypto: drbg - SP800-90A Deterministic Random Bit Generator
      crypto: drbg - header file for DRBG
      crypto: drbg - DRBG kernel configuration options
      crypto: drbg - compile the DRBG code
      crypto: drbg - DRBG testmgr test vectors
      crypto: drbg - Add DRBG test code to testmgr
      crypto: drbg - simplify ordering of linked list in drbg_ctr_df
      crypto: drbg - fix memory corruption for AES192
      crypto: drbg - use of kernel linked list
      crypto: drbg - cleanup of preprocessor macros
      crypto: drbg - Fix format string for debugging statements
      crypto: drbg - Call CTR DRBG DF function only once
      crypto: drbg - Select correct DRBG core for stdrng
      crypto: drbg - Mix a time stamp into DRBG state
      crypto: drbg - HMAC-SHA1 DRBG has crypto strength of 128 bits
      crypto: drbg - fix failure of generating multiple of 2**16 bytes

Tadeusz Struk (22):
      crypto: qat - Intel(R) QAT driver framework
      crypto: qat - Intel(R) QAT transport code
      crypto: qat - Intel(R) QAT FW interface
      crypto: qat - Intel(R) QAT crypto interface
      crypto: qat - Intel(R) QAT ucode part of fw loader
      crypto: qat - Intel(R) QAT accelengine part of fw loader
      crypto: qat - Intel(R) QAT DH895xcc accelerator
      crypto: qat - Update to makefiles
      crypto: qat - Fix random config build warnings
      crypto: qat - Updated Firmware Info Metadata
      crypto: qat - Fixed new checkpatch warnings
      crypto: qat - Fix error path crash when no firmware is present
      crypto: qat - remove unnecessary return codes
      crypto: qat - checkpatch blank lines
      crypto: qat - remove unneeded header
      crypto: qat - remove unnecessary parentheses
      crypto: qat - use min_t macro
      crypto: qat - change slice->regions to slice->region
      crypto: qat - change ae_num to ae_id
      crypto: qat - Updated print outputs
      crypto: qat - Use hweight for bit counting
      crypto: qat - Fixed SKU1 dev issue

Tom Lendacky (6):
      crypto: ccp - Modify PCI support in prep for arm64 support
      crypto: ccp - CCP device bindings documentation
      crypto: ccp - Add platform device support for arm64
      crypto: ccp - Base AXI DMA cache settings on device tree
      crypto: ccp - Remove "select OF" from Kconfig
      crypto: ccp - Do not sign extend input data to CCP

chandramouli narayanan (1):
      crypto: aes - AES CTR x86_64 "by8" AVX optimization

 .../devicetree/bindings/crypto/amd-ccp.txt         |   19 +
 .../devicetree/bindings/crypto/qcom-qce.txt        |   25 +
 Documentation/ioctl/ioctl-number.txt               |    1 +
 MAINTAINERS                                        |    6 +
 arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi      |    3 +-
 arch/x86/crypto/Makefile                           |    4 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |  546 ++++++
 arch/x86/crypto/aesni-intel_glue.c                 |   40 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  281 ++-
 arch/x86/crypto/des3_ede-asm_64.S                  |  805 ++++++++
 arch/x86/crypto/des3_ede_glue.c                    |  509 +++++
 crypto/Kconfig                                     |   50 +-
 crypto/Makefile                                    |    1 +
 crypto/algapi.c                                    |   14 +
 crypto/cryptd.c                                    |   12 +-
 crypto/des_generic.c                               |   22 +-
 crypto/drbg.c                                      | 2044 ++++++++++++++++++++
 crypto/eseqiv.c                                    |    8 +-
 crypto/gcm.c                                       |   30 +-
 crypto/lzo.c                                       |    8 +-
 crypto/seqiv.c                                     |   16 +-
 crypto/tcrypt.c                                    |  114 +-
 crypto/testmgr.c                                   |  304 ++-
 crypto/testmgr.h                                   | 1158 +++++++++--
 drivers/crypto/Kconfig                             |   20 +-
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/amcc/crypto4xx_core.c               |    2 +-
 drivers/crypto/atmel-sha.c                         |    9 +-
 drivers/crypto/atmel-tdes.c                        |    8 +-
 drivers/crypto/caam/caamalg.c                      |   80 +-
 drivers/crypto/caam/caamhash.c                     |  186 +-
 drivers/crypto/caam/caamrng.c                      |   79 +-
 drivers/crypto/caam/ctrl.c                         |   76 +-
 drivers/crypto/caam/desc.h                         |    1 -
 drivers/crypto/caam/intern.h                       |    1 +
 drivers/crypto/caam/jr.c                           |    6 +-
 drivers/crypto/caam/regs.h                         |  105 +-
 drivers/crypto/ccp/Makefile                        |    5 +
 drivers/crypto/ccp/ccp-dev.c                       |   34 +
 drivers/crypto/ccp/ccp-dev.h                       |   14 +-
 drivers/crypto/ccp/ccp-ops.c                       |   26 +-
 drivers/crypto/ccp/ccp-pci.c                       |   39 +-
 drivers/crypto/ccp/ccp-platform.c                  |  230 +++
 drivers/crypto/nx/nx-842.c                         |    2 +-
 drivers/crypto/qat/Kconfig                         |   23 +
 drivers/crypto/qat/Makefile                        |    2 +
 drivers/crypto/qat/qat_common/Makefile             |   14 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |  205 ++
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |  168 ++
 drivers/crypto/qat/qat_common/adf_aer.c            |  259 +++
 drivers/crypto/qat/qat_common/adf_cfg.c            |  361 ++++
 drivers/crypto/qat/qat_common/adf_cfg.h            |   87 +
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |  100 +
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |   83 +
 drivers/crypto/qat/qat_common/adf_cfg_user.h       |   94 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |  192 ++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |  490 +++++
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |  215 ++
 drivers/crypto/qat/qat_common/adf_init.c           |  388 ++++
 drivers/crypto/qat/qat_common/adf_transport.c      |  567 ++++++
 drivers/crypto/qat/qat_common/adf_transport.h      |   63 +
 .../qat/qat_common/adf_transport_access_macros.h   |  160 ++
 .../crypto/qat/qat_common/adf_transport_debug.c    |  304 +++
 .../crypto/qat/qat_common/adf_transport_internal.h |  118 ++
 drivers/crypto/qat/qat_common/icp_qat_fw.h         |  316 +++
 .../crypto/qat/qat_common/icp_qat_fw_init_admin.h  |  131 ++
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h      |  404 ++++
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   78 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h        |  125 ++
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |  305 +++
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |  377 ++++
 drivers/crypto/qat/qat_common/qat_algs.c           | 1038 ++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |  284 +++
 drivers/crypto/qat/qat_common/qat_crypto.h         |   83 +
 drivers/crypto/qat/qat_common/qat_hal.c            | 1393 +++++++++++++
 drivers/crypto/qat/qat_common/qat_uclo.c           | 1181 +++++++++++
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    8 +
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |  144 ++
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |  214 ++
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |   86 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |  449 +++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |   67 +
 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c   |  159 ++
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  266 +++
 drivers/crypto/qat/qat_dh895xcc/qat_admin.c        |  107 +
 drivers/crypto/qce/Makefile                        |    6 +
 drivers/crypto/qce/ablkcipher.c                    |  431 +++++
 drivers/crypto/qce/cipher.h                        |   68 +
 drivers/crypto/qce/common.c                        |  438 +++++
 drivers/crypto/qce/common.h                        |  102 +
 drivers/crypto/qce/core.c                          |  286 +++
 drivers/crypto/qce/core.h                          |   68 +
 drivers/crypto/qce/dma.c                           |  186 ++
 drivers/crypto/qce/dma.h                           |   58 +
 drivers/crypto/qce/regs-v5.h                       |  334 ++++
 drivers/crypto/qce/sha.c                           |  588 ++++++
 drivers/crypto/qce/sha.h                           |   81 +
 drivers/crypto/ux500/cryp/cryp_core.c              |   25 +-
 include/crypto/aead.h                              |    4 +-
 include/crypto/algapi.h                            |    6 +
 include/crypto/des.h                               |    3 +
 include/crypto/drbg.h                              |  290 +++
 include/crypto/hash.h                              |    4 +-
 include/crypto/internal/skcipher.h                 |    3 +-
 include/crypto/scatterwalk.h                       |    6 -
 include/crypto/skcipher.h                          |    4 +-
 include/linux/crypto.h                             |    8 +-
 kernel/module.c                                    |    4 -
 108 files changed, 20473 insertions(+), 583 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

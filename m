Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3BWCeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 21:34:18 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:60001 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757583Ab3BWCeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 21:34:16 -0500
Date: Sat, 23 Feb 2013 10:33:32 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.9
Message-ID: <20130223023331.GA11002@gondor.apana.org.au>
References: <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214103156.GA5840@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.9:

* Added accelerated implementation of crc32 using pclmulqdq.
* Added test vector for fcrypt.
* Added support for OMAP4/AM33XX cipher and hash.
* Fixed loose crypto_user input checks.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexander Boyko (1):
      crypto: crc32 - add crc32 pclmulqdq implementation and wrappers for table implementation

Herbert Xu (1):
      crypto: crc32-pclmul - Kill warning on x86-32

Jingoo Han (1):
      crypto: s5p-sss - Use devm_clk_get()

Julia Lawall (3):
      crypto: bfin_crc - reposition free_irq to avoid access to invalid data
      crypto: atmel-aes - adjust duplicate test
      crypto: use ERR_CAST

Jussi Kivilinna (13):
      crypto: testmgr - add test vector for fcrypt
      crypto: x86/aes - assembler clean-ups: use ENTRY/ENDPROC, localize jump targets
      crypto: aesni-intel - add ENDPROC statements for assembler functions
      crypto: blowfish-x86_64: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: camellia-x86_64/aes-ni: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: cast5-avx: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: cast6-avx: use ENTRY()/ENDPROC() for assembler functions
      crypto: x86/crc32c - assembler clean-up: use ENTRY/ENDPROC
      crypto: x86/ghash - assembler clean-up: use ENDPROC at end of assember functions
      crypto: x86/salsa20 - assembler cleanup, use ENTRY/ENDPROC for assember functions and rename ECRYPT_* to salsa20_*
      crypto: x86/serpent - use ENTRY/ENDPROC for assember functions and localize jump targets
      crypto: x86/sha1 - assembler clean-ups: use ENTRY/ENDPROC
      crypto: x86/twofish - assembler clean-ups: use ENTRY/ENDPROC, localize jump labels

Mark A. Greer (20):
      crypto: omap-sham - Remove unnecessary pr_info noise
      crypto: omap-sham - Convert to use pm_runtime API
      crypto: omap-sham - Add suspend/resume support
      crypto: omap-sham - Add code to use dmaengine API
      crypto: omap-sham - Remove usage of private DMA API
      crypto: omap-sham - Add Device Tree Support
      crypto: omap-sham - Convert to dma_request_slave_channel_compat()
      crypto: omap-sham - Add OMAP4/AM33XX SHAM Support
      crypto: omap-sham - Add SHA224 and SHA256 Support
      crypto: omap-aes - Remmove unnecessary pr_info noise
      crypto: omap-aes - Don't reset controller for every operation
      crypto: omap-aes - Convert to use pm_runtime API
      crypto: omap-aes - Add suspend/resume support
      crypto: omap-aes - Add code to use dmaengine API
      crypto: omap-aes - Remove usage of private DMA API
      crypto: omap-aes - Add Device Tree Support
      crypto: omap-aes - Convert to dma_request_slave_channel_compat()
      crypto: omap-aes - Add OMAP4/AM33XX AES Support
      crypto: omap-aes - Add CTR algorithm Support
      crypto: omap-sham - Fix compile errors when CONFIG_OF not defined

Mathias Krause (3):
      crypto: user - fix info leaks in report API
      crypto: user - fix empty string test in report API
      crypto: user - ensure user supplied strings are nul-terminated

Vakul Garg (1):
      crypto: caam - Added property fsl,sec-era in SEC4.0 device tree binding.

 .../devicetree/bindings/crypto/fsl-sec4.txt        |   12 +-
 arch/x86/crypto/Makefile                           |    2 +
 arch/x86/crypto/aes-i586-asm_32.S                  |   15 +-
 arch/x86/crypto/aes-x86_64-asm_64.S                |   30 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   23 +-
 arch/x86/crypto/blowfish-x86_64-asm_64.S           |   39 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |   38 +-
 arch/x86/crypto/camellia-x86_64-asm_64.S           |   50 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |   48 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |   35 +-
 arch/x86/crypto/crc32-pclmul_asm.S                 |  246 ++++++
 arch/x86/crypto/crc32-pclmul_glue.c                |  201 +++++
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |    8 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    4 +
 arch/x86/crypto/salsa20-i586-asm_32.S              |   28 +-
 arch/x86/crypto/salsa20-x86_64-asm_64.S            |   28 +-
 arch/x86/crypto/salsa20_glue.c                     |    5 -
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |   35 +-
 arch/x86/crypto/serpent-sse2-i586-asm_32.S         |   20 +-
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S       |   20 +-
 arch/x86/crypto/sha1_ssse3_asm.S                   |   10 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |   35 +-
 arch/x86/crypto/twofish-i586-asm_32.S              |   11 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |   20 +-
 arch/x86/crypto/twofish-x86_64-asm_64.S            |   11 +-
 crypto/Kconfig                                     |   21 +
 crypto/Makefile                                    |    1 +
 crypto/ablkcipher.c                                |   12 +-
 crypto/aead.c                                      |   15 +-
 crypto/ahash.c                                     |    2 +-
 crypto/algapi.c                                    |    4 +-
 crypto/authenc.c                                   |    3 +-
 crypto/authencesn.c                                |    3 +-
 crypto/blkcipher.c                                 |   12 +-
 crypto/ccm.c                                       |   23 +-
 crypto/chainiv.c                                   |    3 +-
 crypto/crc32.c                                     |  158 ++++
 crypto/crypto_user.c                               |   38 +-
 crypto/ctr.c                                       |    3 +-
 crypto/cts.c                                       |    3 +-
 crypto/gcm.c                                       |   29 +-
 crypto/pcompress.c                                 |    3 +-
 crypto/rng.c                                       |    2 +-
 crypto/seqiv.c                                     |    3 +-
 crypto/shash.c                                     |    3 +-
 crypto/testmgr.c                                   |   15 +
 drivers/crypto/atmel-aes.c                         |    2 +-
 drivers/crypto/bfin_crc.c                          |    6 +-
 drivers/crypto/omap-aes.c                          |  658 +++++++++++----
 drivers/crypto/omap-sham.c                         |  915 +++++++++++++++-----
 drivers/crypto/s5p-sss.c                           |    4 +-
 51 files changed, 2153 insertions(+), 762 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

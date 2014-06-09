Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaFIK7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:59:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49037 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaFIK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:59:20 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2] crypto: Add Allwinner Security System crypto accelerator
Date: Mon,  9 Jun 2014 12:59:07 +0200
Message-Id: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This is the driver for the Security System included in Allwinner SoC A20.
The Security System (SS for short) is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
It could be found on others Allwinner SoC: 
- A10s and A31 diagram speak about it with precisions (AES/DES/3DES/Md5/SHA1/PRNG)
- A10 and A13 manual give the same datasheet for SS than A20
- A23 speak about a security system but without precisions
But I do not have access on any of those hardware, tests are welcome.

This driver currently supports:
- MD5 and SHA1 hash algorithms
- AES block cipher in CBC mode with 128/196/256bits keys.
- DES and 3DES block cipher in CBC mode
- PRNG
The driver exposes all those algorithms through the kernel cryptographic API.

The driver support only CPU driven (aka poll mode) transfer mode since the DMA engine of the A20 does not have a driver yet.

Changes since v1:
- annotate ss->base as __iomem
- regroup all mutex in the ss_ctx structure
- splited driver in 7 modules (core md5 sha1 aes des 3des prng) in sunxi-ss directory
- use dev_exit_p() for .remove
- added missing CRYPTO_BLKCIPHER dep in Kconfig
- use ahash instead of shash
- use ablkcipher instead of blkcipher
- use crypto_rng_ctx instead of crypto_tfm_ctx
- set seed as an u32
- drop useless comment decoration
- drop useless debug
- ss_ctx is now a static pointer and whole structure being allocated
- fix the platform_get_resource/devm_ioremap_resource pattern
- invert getting die id and configuring clock
- set clock value as a const unsigned long
- add MODULE_ALIAS
- use define names more consistency (SS_xxx)
- fix PRNG errors
- respell SS to Security System in DT documentation

Regards.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaCHXu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:50:58 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:60394 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaCHXux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:50:53 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH 0/6] SP800-90A Deterministic Random Bit Generator
Date: Sun, 09 Mar 2014 00:43:33 +0100
Message-ID: <2396177.vxvG2ljJL8@myon.chronox.de>
User-Agent: KMail/4.12.2 (Linux/3.13.5-200.fc20.x86_64; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following set of patches implements the deterministic random bit generator
(DRBG) specified by SP800-90A.

The DRBG implementation offers the following:

	* All three DRBG types are implemented with a derivation function.
	* All DRBG types are available with and without prediction resistance.
	* All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
	  for the HMAC and Hash DRBGs.
	* All AES types of AES-128, AES-192 and AES-256 are available for the
	  CTR DRBG.
	* A self test is implemented with drbg_healthcheck().
	* The FIPS 140-2 continuous self test is implemented.
	* Additional cipher primitives, such as Serpent or Twofish, can be
	  added to the DRBG without changing the implementation. The only
	  change necessary is to the DRBG definition given in the cores[]
	  array.

As defined in SP800-131A, the ANSI X9.31 DRNG is to be sunset by the end of 
this year for official uses, including FIPS 140-2 compliance.

Additional tests are available at [1].

[1] http://www.chronox.de/drbg.html

Stephan Mueller (6):
  SP800-90A Deterministic Random Bit Generator
  header file for DRBG
  DRBG kernel configuration options
  compile the DRBG code
  DRBG testmgr test vectors
  Add DRBG test code to testmgr

 crypto/Kconfig        |   36 +-
 crypto/Makefile       |    1 +
 crypto/drbg.c         | 1941 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c      |  269 +++++++
 crypto/testmgr.h      |  877 ++++++++++++++++++++++
 include/crypto/drbg.h |  340 +++++++++
 6 files changed, 3463 insertions(+), 1 deletion(-)
 create mode 100644 crypto/drbg.c
 create mode 100644 include/crypto/drbg.h

-- 
1.8.5.3

,



Ciao
Stephan
-- 
| Cui bono? |

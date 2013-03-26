Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3CZU6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:58:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:51732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab3CZU6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="307788735"
Subject: [PATCH v2 00/10] Optimize SHA256 and SHA512 for Intel x86_64 with
 SSSE3, AVX or AVX2 instructions
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Mar 2013 13:58:39 -0700
Message-ID: <1364331519.27102.10.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert, 

The following patch series provides optimized SHA256 and SHA512 routines
using the SSSE3, AVX or AVX2 instructions on x86_64 for Intel cpus.
Depending on cpu capabilities, speedup between 40% to 70% or more can be achieved
over the generic SHA256 and SHA512 routines.

Tim

Version 2:

1. Check AVX2 feature directly in glue code
2. Add CONFGI_AS_AVX2 check for AVX2 code
3. Use ENTRY/ENDPROC macros for assembly routines
4. Fix SSSE3 feature check in glue code

Thanks to Peter Anvin, Jussi Kivilinna and Jim Kukunas for their reviews and comments.

Tim Chen (10):
  Expose SHA256 generic routine to be callable externally.
  Optimized sha256 x86_64 assembly routine using Supplemental SSE3
    instructions.
  Optimized sha256 x86_64 assembly routine with AVX instructions.
  Optimized sha256 x86_64 routine using AVX2's RORX instructions
  Create module providing optimized SHA256 routines using SSSE3, AVX or
    AVX2 instructions.
  Expose generic sha512 routine to be callable from other modules
  Optimized SHA512 x86_64 assembly routine using Supplemental SSE3
    instructions.
  Optimized SHA512 x86_64 assembly routine using AVX instructions.
  Optimized SHA512 x86_64 assembly routine using AVX2 RORX instruction.
  Create module providing optimized SHA512 routines using SSSE3, AVX or
    AVX2 instructions.

 arch/x86/crypto/Makefile            |   4 +
 arch/x86/crypto/sha256-avx-asm.S    | 496 +++++++++++++++++++++++
 arch/x86/crypto/sha256-avx2-asm.S   | 772 ++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha256-ssse3-asm.S  | 506 +++++++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c | 275 +++++++++++++
 arch/x86/crypto/sha512-avx-asm.S    | 423 ++++++++++++++++++++
 arch/x86/crypto/sha512-avx2-asm.S   | 743 ++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha512-ssse3-asm.S  | 421 ++++++++++++++++++++
 arch/x86/crypto/sha512_ssse3_glue.c | 282 +++++++++++++
 crypto/Kconfig                      |  22 +
 crypto/sha256_generic.c             |  11 +-
 crypto/sha512_generic.c             |  13 +-
 include/crypto/sha.h                |   5 +
 13 files changed, 3962 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/crypto/sha256-avx-asm.S
 create mode 100644 arch/x86/crypto/sha256-avx2-asm.S
 create mode 100644 arch/x86/crypto/sha256-ssse3-asm.S
 create mode 100644 arch/x86/crypto/sha256_ssse3_glue.c
 create mode 100644 arch/x86/crypto/sha512-avx-asm.S
 create mode 100644 arch/x86/crypto/sha512-avx2-asm.S
 create mode 100644 arch/x86/crypto/sha512-ssse3-asm.S
 create mode 100644 arch/x86/crypto/sha512_ssse3_glue.c

-- 
1.7.11.7



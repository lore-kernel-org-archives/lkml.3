Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaHQPqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:46:14 -0400
Received: from mail.eperm.de ([89.247.134.16]:53659 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaHQPqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:46:13 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 0/8] DRBG: efficiency patches
Date: Sun, 17 Aug 2014 17:37:04 +0200
Message-ID: <7044529.FG2KhbPc9P@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch set contains random fixes to increase the efficiency of
the DRBG. Changes include the removal of unneeded memset(0) and sanity
checks. All changes do not weaken the implementation as only code is
removed that is clearly covered by other code paths.

In addition, the cpu_to_be kernel function together with a type cast is
used to convert an integer into its string representation. This patch
increases the speed of the DRBG by 10%.

Stephan Mueller (8):
  DRBG: replace int2byte with cpu_to_be
  DRBG: kzfree does not need a check for NULL pointer
  DRBG: remove superflowous checks
  DRBG: remove superflowous memset(0)
  DRBG: use kmalloc instead of kzalloc for V and C
  DRBG: remove unnecessary sanity checks
  DRBG: remove configuration of fixed values
  DRBG: remove unnecessary sanity check for shadow state

 crypto/drbg.c         | 130 ++++++++++++++++----------------------------------
 include/crypto/drbg.h |  19 +++-----
 2 files changed, 46 insertions(+), 103 deletions(-)

-- 
1.9.3



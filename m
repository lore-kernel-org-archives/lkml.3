Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967607Ab3E3G0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:26:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2319 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966921Ab3E3G0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:26:02 -0400
X-Spam-Score: -100.8
Message-ID: <51A6F0C6.9050806@asianux.com>
Date: Thu, 30 May 2013 14:25:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: m68k: math-emu: unsigned issue, 'unsigned long' will
 never be less than zero.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'oldmant.m32[1]' is 'unsigned long' which never '< 0', and the original
author wanted to check the highest bit whether set.

So need type cast form 'unsigned long' to 'long'.

The related warning: (with EXTRA_CFLAGS=-W ARCH=m68k for allmodconfig)
  arch/m68k/math-emu/fp_arith.c:522:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m68k/math-emu/fp_arith.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/math-emu/fp_arith.c b/arch/m68k/math-emu/fp_arith.c
index 08f286d..ef013c5 100644
--- a/arch/m68k/math-emu/fp_arith.c
+++ b/arch/m68k/math-emu/fp_arith.c
@@ -519,7 +519,7 @@ static void fp_roundint(struct fp_ext *dest, int mode)
 				return;
 			break;
 		case 0x401e:
-			if (!(oldmant.m32[1] >= 0))
+			if (!((long)oldmant.m32[1] >= 0))
 				return;
 			if (oldmant.m32[0] & 1)
 				break;
-- 
1.7.7.6

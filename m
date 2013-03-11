Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3CKX3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:29:09 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58089 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab3CKX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:29:07 -0400
Message-ID: <1363044544.3137.120.camel@x61.thuisdomein>
Subject: [PATCH] decompressors: fix typo "POWERPC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Florian Fainelli <florian@openwrt.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 00:29:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 23:29:03.0956 (UTC) FILETIME=[37CCA940:01CE1EB0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5dc49c75a26b99e86a18441e0b64c1f7c7c6a500 ("decompressors: make
the default XZ_DEC_* config match the selected architecture") added
	default y if POWERPC

to lib/xz/Kconfig. But there is no Kconfig symbol POWERPC. The most
general Kconfig symbol for the powerpc architecture is PPC. So let's use
that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=powerpc oldconfig" (on some powerpc
defconfig).

1) By the way: why does the XZ related code use both the macro
CONFIG_XZ_DEC_POWERPC and the macro XZ_DEC_POWERPC? (Ditto for other
architectures.) That looks odd.

 lib/xz/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index 82a04d7..08837db 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -15,7 +15,7 @@ config XZ_DEC_X86
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder"
-	default y if POWERPC
+	default y if PPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-- 
1.7.11.7


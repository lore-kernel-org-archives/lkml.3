Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3CLUfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:35:22 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:49505 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514Ab3CLUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:35:21 -0400
Message-ID: <1363120519.3137.148.camel@x61.thuisdomein>
Subject: [PATCH] sparc: delete "if !ULTRA_HAS_POPULATION_COUNT"
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 21:35:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 20:35:19.0851 (UTC) FILETIME=[1CF637B0:01CE1F61]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2d78d4beb64eb07d50665432867971c481192ebf ("[PATCH] bitops:
sparc64: use generic bitops") made the default of GENERIC_HWEIGHT depend
on !ULTRA_HAS_POPULATION_COUNT. But since there's no Kconfig symbol with
that name, this always evaluates to true. Delete this dependency.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=sparc menuconfig" (before and after this
patch).

1) There apparently is an (obscure) preprocessor macro
ULTRA_HAS_POPULATION_COUNT. But the check for it got removed in commit
ef7c4d4675d2a9206f913f26ca1a5cd41bff9d41 ("sparc: Use popc if possible
for hweight routines."). 

 arch/sparc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 289127d..7fcd4b4 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -197,7 +197,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config GENERIC_HWEIGHT
 	bool
-	default y if !ULTRA_HAS_POPULATION_COUNT
+	default y
 
 config GENERIC_CALIBRATE_DELAY
 	bool
-- 
1.7.11.7


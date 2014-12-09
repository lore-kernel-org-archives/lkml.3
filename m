Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaLIUC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:02:26 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50804 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaLIUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:02:25 -0500
Message-ID: <1418155343.2058.99.camel@x220>
Subject: [PATCH] nios2: enable "make defconfig"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ley Foon Tan <lftan@altera.com>
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 21:02:23 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2014 20:02:23.0864 (UTC) FILETIME=[0C514780:01D013EB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running "make defconfig" currently fails for nios2:
    $ make ARCH=nios2 defconfig
    scripts/kconfig/conf --defconfig Kconfig
    ***
    *** Can't find default configuration "arch/nios2/defconfig"!
    ***
    make[1]: *** [defconfig] Error 1
    make: *** [defconfig] Error 2

Add a definition for KBUILD_DEFCONFIG to the nios2's main Makefile to
enable this make target.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/nios2/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/nios2/Makefile b/arch/nios2/Makefile
index e142c9ee51fa..2328f82ba2a8 100644
--- a/arch/nios2/Makefile
+++ b/arch/nios2/Makefile
@@ -14,6 +14,8 @@
 # Nios2 port by Wind River Systems Inc trough:
 #   fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
 
+KBUILD_DEFCONFIG := 3c120_defconfig
+
 UTS_SYSNAME = Linux
 
 export MMU
-- 
1.9.3


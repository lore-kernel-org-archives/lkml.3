Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaIXSc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:32:26 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60094 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbaIXScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:32:24 -0400
Message-ID: <1411583542.19525.22.camel@x220>
Subject: [PATCH] ARC: Remove unneeded Kconfig entry NO_DMA
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 20:32:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 18:32:23.0231 (UTC) FILETIME=[E1E514F0:01CFD825]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures only need a Kconfig entry for NO_DMA if it is possible
that its value will be 'y'. For arc its value will always be 'n', making
it pointless. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by playing with arch/arc/configs/tb10x_defconfig. The only
difference this change should make, is that the line reading
    # CONFIG_NO_DMA is not set

is dropped from the .config file after "make oldconfig". That should
have no impact whatsoever on the build.

 arch/arc/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 32b4f8ecf3f0..2a08449ef1c7 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -73,9 +73,6 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
-config NO_DMA
-	def_bool n
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
-- 
1.9.3


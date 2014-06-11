Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaFKJLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:11:53 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64551 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130AbaFKI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:52 -0400
Message-ID: <1402477070.3798.54.camel@x220>
Subject: [PATCH] ARC: remove checks for CONFIG_ARC_MMU_V4
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 10:57:50 +0200
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751A6B701C@IN01WEMBXA.internal.synopsys.com>
References: <1402475161.3798.49.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751A6B701C@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 08:57:50.0667 (UTC) FILETIME=[394581B0:01CF8553]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no Kconfig symbol ARC_MMU_V4 so the checks for CONFIG_ARC_MMU_V4
will always evaluate to false. Remove them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested!

It would be nice if this could be squashed into commit ef680cdc2437
("ARC: Disable caches in early boot if so configured"). But I guess the
ARC tree that is included in linux-next cannot be rebased.

 arch/arc/include/asm/cache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/cache.h b/arch/arc/include/asm/cache.h
index c1d3d2da1191..b3c750979aa1 100644
--- a/arch/arc/include/asm/cache.h
+++ b/arch/arc/include/asm/cache.h
@@ -60,7 +60,7 @@ extern void read_decode_cache_bcr(void);
 #define ARC_REG_IC_IVIC		0x10
 #define ARC_REG_IC_CTRL		0x11
 #define ARC_REG_IC_IVIL		0x19
-#if defined(CONFIG_ARC_MMU_V3) || defined (CONFIG_ARC_MMU_V4)
+#if defined(CONFIG_ARC_MMU_V3)
 #define ARC_REG_IC_PTAG		0x1E
 #endif
 
@@ -74,7 +74,7 @@ extern void read_decode_cache_bcr(void);
 #define ARC_REG_DC_IVDL		0x4A
 #define ARC_REG_DC_FLSH		0x4B
 #define ARC_REG_DC_FLDL		0x4C
-#if defined(CONFIG_ARC_MMU_V3) || defined (CONFIG_ARC_MMU_V4)
+#if defined(CONFIG_ARC_MMU_V3)
 #define ARC_REG_DC_PTAG		0x5C
 #endif
 
-- 
1.9.3


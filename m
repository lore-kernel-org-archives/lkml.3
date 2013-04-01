Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab3DASDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:03:10 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52170 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab3DASDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:03:08 -0400
Message-ID: <1364839386.21627.71.camel@x61.thuisdomein>
Subject: [PATCH 8/8] cris: do not export "u8" and friends to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 20:03:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 18:03:07.0018 (UTC) FILETIME=[29A17EA0:01CE2F03]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sv_addr_ag.h exports "u8" and friends to userspace. Use "__u8" and
friends instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h b/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
index 5517f04..199d053 100644
--- a/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
+++ b/arch/cris/include/uapi/arch-v10/arch/sv_addr_ag.h
@@ -64,10 +64,10 @@
 /*--- Obsolete. Kept for backw compatibility. ---*/
 /* Reads (or writes) a byte/uword/udword from the specified mode
    register. */
-#define IO_RD(reg) (*(volatile u32*)(reg))
-#define IO_RD_B(reg) (*(volatile u8*)(reg))
-#define IO_RD_W(reg) (*(volatile u16*)(reg))
-#define IO_RD_D(reg) (*(volatile u32*)(reg))
+#define IO_RD(reg) (*(volatile __u32*)(reg))
+#define IO_RD_B(reg) (*(volatile __u8*)(reg))
+#define IO_RD_W(reg) (*(volatile __u16*)(reg))
+#define IO_RD_D(reg) (*(volatile __u32*)(reg))
 
 /*------------------------------------------------------------
 !* Start addresses of the different memory areas.
@@ -97,12 +97,12 @@
 !*-----------------------------------------------------------*/
 
 #ifndef __ASSEMBLER__
-# define  IO_TYPECAST_UDWORD  (volatile u32*)
-# define  IO_TYPECAST_RO_UDWORD  (const volatile u32*)
-# define  IO_TYPECAST_UWORD  (volatile u16*)
-# define  IO_TYPECAST_RO_UWORD  (const volatile u16*)
-# define  IO_TYPECAST_BYTE  (volatile u8*)
-# define  IO_TYPECAST_RO_BYTE  (const volatile u8*)
+# define  IO_TYPECAST_UDWORD  (volatile __u32*)
+# define  IO_TYPECAST_RO_UDWORD  (const volatile __u32*)
+# define  IO_TYPECAST_UWORD  (volatile __u16*)
+# define  IO_TYPECAST_RO_UWORD  (const volatile __u16*)
+# define  IO_TYPECAST_BYTE  (volatile __u8*)
+# define  IO_TYPECAST_RO_BYTE  (const volatile __u8*)
 #else
 # define  IO_TYPECAST_UDWORD
 # define  IO_TYPECAST_RO_UDWORD
-- 
1.7.11.7


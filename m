Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3CZXWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:22:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3CZWwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 17/72] sfc: Add parentheses around use of bitfield macro arguments
Date: Tue, 26 Mar 2013 15:51:00 -0700
Message-Id: <20130326224921.495021281@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 9724a8504c875145f5a513bb8eca50671cee23b4 ]

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/bitfield.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -120,10 +120,10 @@ typedef union efx_oword {
  * [0,high-low), with garbage in bits [high-low+1,...).
  */
 #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
-	(((low > max) || (high < min)) ? 0 :				\
-	 ((low > min) ?							\
-	  ((native_element) >> (low - min)) :				\
-	  ((native_element) << (min - low))))
+	((low) > (max) || (high) < (min) ? 0 :				\
+	 (low) > (min) ?						\
+	 (native_element) >> ((low) - (min)) :				\
+	 (native_element) << ((min) - (low)))
 
 /*
  * Extract bit field portion [low,high) from the 64-bit little-endian
@@ -142,27 +142,27 @@ typedef union efx_oword {
 #define EFX_EXTRACT_OWORD64(oword, low, high)				\
 	((EFX_EXTRACT64((oword).u64[0], 0, 63, low, high) |		\
 	  EFX_EXTRACT64((oword).u64[1], 64, 127, low, high)) &		\
-	 EFX_MASK64(high + 1 - low))
+	 EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_EXTRACT_QWORD64(qword, low, high)				\
 	(EFX_EXTRACT64((qword).u64[0], 0, 63, low, high) &		\
-	 EFX_MASK64(high + 1 - low))
+	 EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_EXTRACT_OWORD32(oword, low, high)				\
 	((EFX_EXTRACT32((oword).u32[0], 0, 31, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[1], 32, 63, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[2], 64, 95, low, high) |		\
 	  EFX_EXTRACT32((oword).u32[3], 96, 127, low, high)) &		\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_EXTRACT_QWORD32(qword, low, high)				\
 	((EFX_EXTRACT32((qword).u32[0], 0, 31, low, high) |		\
 	  EFX_EXTRACT32((qword).u32[1], 32, 63, low, high)) &		\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_EXTRACT_DWORD(dword, low, high)			\
 	(EFX_EXTRACT32((dword).u32[0], 0, 31, low, high) &	\
-	 EFX_MASK32(high + 1 - low))
+	 EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_OWORD_FIELD64(oword, field)				\
 	EFX_EXTRACT_OWORD64(oword, EFX_LOW_BIT(field),		\
@@ -442,10 +442,10 @@ typedef union efx_oword {
 	cpu_to_le32(EFX_INSERT_NATIVE(min, max, low, high, value))
 
 #define EFX_INPLACE_MASK64(min, max, low, high)				\
-	EFX_INSERT64(min, max, low, high, EFX_MASK64(high + 1 - low))
+	EFX_INSERT64(min, max, low, high, EFX_MASK64((high) + 1 - (low)))
 
 #define EFX_INPLACE_MASK32(min, max, low, high)				\
-	EFX_INSERT32(min, max, low, high, EFX_MASK32(high + 1 - low))
+	EFX_INSERT32(min, max, low, high, EFX_MASK32((high) + 1 - (low)))
 
 #define EFX_SET_OWORD64(oword, low, high, value) do {			\
 	(oword).u64[0] = (((oword).u64[0]				\



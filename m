Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386Ab3CZPXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363Ab3CZPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 126/150] sfc: Add parentheses around use of bitfield macro arguments
Date: Tue, 26 Mar 2013 15:20:25 +0000
Message-Id: <1364311249-14454-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 9724a8504c875145f5a513bb8eca50671cee23b4 upstream.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/bitfield.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index b26a954..5400a33 100644
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
-- 
1.8.1.2


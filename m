Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab3DKXSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:18:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585Ab3DKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:22 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=olzZ0DhCA8EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IXgAc-KR_AgA:10 a=zRKbQ67AAAAA:8 a=doupyKFmAAAA:8 a=Dyn6xXozSzX05dqzISsA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=0vUscowIxtUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231620.454454263@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 4/9 ] sfc: Add parentheses around use of bitfield macro arguments
References: <20130411231149.302144972@goodmis.org>
Content-Disposition: inline; filename=0004-sfc-Add-parentheses-around-use-of-bitfield-macro-arg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 9724a8504c875145f5a513bb8eca50671cee23b4 ]

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/bitfield.h |   22 +++++++++++-----------
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
1.7.10.4



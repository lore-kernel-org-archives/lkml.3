Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3LTKhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:37:36 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36122 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab3LTKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:37:32 -0500
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de
Subject: [PATCH 3/3] rlt8192e: Removing unused defines in rltlib_endianfree.h
Date: Fri, 20 Dec 2013 11:29:10 +0100
Message-Id: <1387535350-27442-4-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch mentioned that these macros should be defined with a 'do {...} while(0)' statement.
So we used grep to find all files using these macros and we found out that these macros were only used 
in rtl819x_Qos.h, in the defines we removed before.
Since the macros are not used anywhere else we decided to remove them from the driver.

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>

---
 drivers/staging/rtl8192e/rtllib_endianfree.h | 38 ----------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_endianfree.h b/drivers/staging/rtl8192e/rtllib_endianfree.h
index 39b8204..b189fa5 100644
--- a/drivers/staging/rtl8192e/rtllib_endianfree.h
+++ b/drivers/staging/rtl8192e/rtllib_endianfree.h
@@ -84,15 +84,6 @@
 	  (~BIT_OFFSET_LEN_MASK_32(__BitOffset, __BitLen)) \
 	)
 
-#define SET_BITS_TO_LE_4BYTE(__pStart, __BitOffset, __BitLen, __Value) \
-	*((u32 *)(__pStart)) = \
-	EF4Byte( \
-	LE_BITS_CLEARED_TO_4BYTE(__pStart, __BitOffset, __BitLen) \
-	| \
-	((((u32)__Value) & BIT_LEN_MASK_32(__BitLen)) << (__BitOffset)) \
-	);
-
-
 #define BIT_LEN_MASK_16(__BitLen) \
 	(0xFFFF >> (16 - (__BitLen)))
 
@@ -109,21 +100,6 @@
 	  BIT_LEN_MASK_16(__BitLen) \
 	)
 
-#define LE_BITS_CLEARED_TO_2BYTE(__pStart, __BitOffset, __BitLen) \
-	( \
-	  LE_P2BYTE_TO_HOST_2BYTE(__pStart) \
-	  & \
-	  (~BIT_OFFSET_LEN_MASK_16(__BitOffset, __BitLen)) \
-	)
-
-#define SET_BITS_TO_LE_2BYTE(__pStart, __BitOffset, __BitLen, __Value) \
-	*((u16 *)(__pStart)) = \
-	EF2Byte( \
-		LE_BITS_CLEARED_TO_2BYTE(__pStart, __BitOffset, __BitLen) \
-		| ((((u16)__Value) & BIT_LEN_MASK_16(__BitLen)) <<	\
-		(__BitOffset)) \
-	);
-
 #define BIT_LEN_MASK_8(__BitLen) \
 	(0xFF >> (8 - (__BitLen)))
 
@@ -140,20 +116,6 @@
 	  BIT_LEN_MASK_8(__BitLen) \
 	)
 
-#define LE_BITS_CLEARED_TO_1BYTE(__pStart, __BitOffset, __BitLen) \
-	( \
-	  LE_P1BYTE_TO_HOST_1BYTE(__pStart) \
-	  & \
-	  (~BIT_OFFSET_LEN_MASK_8(__BitOffset, __BitLen)) \
-	)
-
-#define SET_BITS_TO_LE_1BYTE(__pStart, __BitOffset, __BitLen, __Value)	\
-	*((u8 *)(__pStart)) = EF1Byte(					\
-		LE_BITS_CLEARED_TO_1BYTE(__pStart, __BitOffset, __BitLen) \
-		| ((((u8)__Value) & BIT_LEN_MASK_8(__BitLen)) <<	\
-		(__BitOffset))						\
-	);
-
 #define	N_BYTE_ALIGMENT(__Value, __Aligment)			\
 	 ((__Aligment == 1) ? (__Value) : (((__Value + __Aligment - 1) / \
 	__Aligment) * __Aligment))
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbbALRXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:23:25 -0500
Received: from mx02.posteo.de ([89.146.194.165]:35418 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbALRXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:23:23 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mingo@kernel.org
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        maxime.coquelin@st.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH v2] bitops.h: add sign_extend8(), 16 and 64 functions
Date: Mon, 12 Jan 2015 18:22:50 +0100
Message-Id: <1421083370-24924-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds helper functions for sign-extending signed values of any lower
(hardware-)given size to s8, s16 or s64 respectively, just like sign_extend32()
for s32.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
---
 include/linux/bitops.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 5d858e0..9c31680 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -161,6 +161,28 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
 }
 
 /**
+ * sign_extend8 - sign extend a 8-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<8) to sign bit
+ */
+static inline __s8 sign_extend8(__u8 value, int index)
+{
+	__u8 shift = 7 - index;
+	return (__s8)(value << shift) >> shift;
+}
+
+/**
+ * sign_extend16 - sign extend a 16-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<16) to sign bit
+ */
+static inline __s16 sign_extend16(__u16 value, int index)
+{
+	__u8 shift = 15 - index;
+	return (__s16)(value << shift) >> shift;
+}
+
+/**
  * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
  * @value: value to sign extend
  * @index: 0 based bit index (0<=index<32) to sign bit
@@ -171,6 +193,17 @@ static inline __s32 sign_extend32(__u32 value, int index)
 	return (__s32)(value << shift) >> shift;
 }
 
+/**
+ * sign_extend64 - sign extend a 64-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<64) to sign bit
+ */
+static inline __s64 sign_extend64(__u64 value, int index)
+{
+	__u8 shift = 63 - index;
+	return (__s64)(value << shift) >> shift;
+}
+
 static inline unsigned fls_long(unsigned long l)
 {
 	if (sizeof(l) == 4)
-- 
2.1.4


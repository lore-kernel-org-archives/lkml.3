Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbbATMbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:31:40 -0500
Received: from mx02.posteo.de ([89.146.194.165]:55619 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbbATMbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:31:37 -0500
From: Martin Kepplinger <martink@posteo.de>
To: torvalds@linux-foundation.org, jsrhbz@kanargh.force9.co.uk,
        christoph.muellner@theobroma-systems.com, linux@roeck-us.net,
        linux@rasmusvillemoes.dk, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, maxime.coquelin@st.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tytso@mit.edu
Cc: linux-tip-commits@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 2/2] bitops.h: Add sign_extend64() API
Date: Tue, 20 Jan 2015 13:30:55 +0100
Message-Id: <1421757055-8234-3-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421757055-8234-1-git-send-email-martink@posteo.de>
References: <CA+55aFycO_d0oO9rw9fXa13NSNc0Am8v+3rV+eSH9YdsCi-2Mg@mail.gmail.com>
 <1421757055-8234-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sign_extend64() for sign extending any (hardware-)given signed value
greater than 32 bits to s64.

Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 include/linux/bitops.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 336f22b..2fd47c8 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -173,6 +173,17 @@ static inline __s32 sign_extend32(__u32 value, int index)
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


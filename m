Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbARTIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:08:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbARTIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:08:14 -0500
Date: Sun, 18 Jan 2015 11:06:47 -0800
From: tip-bot for Martin Kepplinger <tipbot@zytor.com>
Message-ID: <tip-7e9358073d3f0ed0a028c48aa54009b3296dffc9@git.kernel.org>
Cc: martink@posteo.de, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux@rasmusvillemoes.dk,
        christoph.muellner@theobroma-systems.com, jsrhbz@kanargh.force9.co.uk,
        hpa@zytor.com, mingo@kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org, linux@roeck-us.net,
        tglx@linutronix.de, tytso@mit.edu, maxime.coquelin@st.com
Reply-To: martink@posteo.de, christoph.muellner@theobroma-systems.com,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux@rasmusvillemoes.dk, linux@roeck-us.net, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jsrhbz@kanargh.force9.co.uk, akpm@linux-foundation.org,
        mingo@kernel.org, maxime.coquelin@st.com, tytso@mit.edu
In-Reply-To: <1421083370-24924-1-git-send-email-martink@posteo.de>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] bitops: Add sign_extend8(), 16 and 64 functions
Git-Commit-ID: 7e9358073d3f0ed0a028c48aa54009b3296dffc9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e9358073d3f0ed0a028c48aa54009b3296dffc9
Gitweb:     http://git.kernel.org/tip/7e9358073d3f0ed0a028c48aa54009b3296dffc9
Author:     Martin Kepplinger <martink@posteo.de>
AuthorDate: Mon, 12 Jan 2015 18:22:50 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 18 Jan 2015 20:03:51 +0100

bitops: Add sign_extend8(), 16 and 64 functions

This adds helper functions for sign-extending signed values of any
lower (hardware-)given size to s8, s16 or s64 respectively, just like
sign_extend32() for s32.

This completes the sign_extend*() API family to work on all bit sizes
like most other bitops APIs do.

Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1421083370-24924-1-git-send-email-martink@posteo.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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

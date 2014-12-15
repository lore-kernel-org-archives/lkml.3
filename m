Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaLORyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:54:46 -0500
Received: from mx02.posteo.de ([89.146.194.165]:47302 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaLORyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:54:44 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] bitops.h: add sign_extend64() function
Date: Mon, 15 Dec 2014 18:54:15 +0100
Message-Id: <1418666055-16657-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141215171702.GR3337@twins.programming.kicks-ass.net>
References: <20141215171702.GR3337@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds sign_exten64 to sign extend any signed value shorter than 64 bits
to a s64.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
---
Without looking for it's users yet: This applies on top of it's 8 and 16 bit
friends.

This reminded me of giving credit for the initial idea. At least in one patch
I'd like to have him mentioned.


 include/linux/bitops.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 70190f4..9c31680 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -193,6 +193,17 @@ static inline __s32 sign_extend32(__u32 value, int index)
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
2.1.3


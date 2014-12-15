Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaLOQTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:19:17 -0500
Received: from mx02.posteo.de ([89.146.194.165]:32853 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaLOQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:12 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/6] bitops.h: add sign_extend8 function
Date: Mon, 15 Dec 2014 17:18:32 +0100
Message-Id: <1418660317-21750-2-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418660317-21750-1-git-send-email-martink@posteo.de>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a helper function that extends any signed value smaller than
8 bits to a s8.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 include/linux/bitops.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 5d858e0..3c2a539 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -161,6 +161,17 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
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
  * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
  * @value: value to sign extend
  * @index: 0 based bit index (0<=index<32) to sign bit
-- 
2.1.3


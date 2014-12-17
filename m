Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaLQFNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:13:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34900 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQFNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:13:19 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: tglx@linutronix.de, davem@davemloft.net, john.stultz@linaro.org,
        dborkman@redhat.com
Cc: arnd@linaro.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
Subject: [PATCH] ktime.h: Introduce ktime_ms_delta
Date: Wed, 17 Dec 2014 13:11:35 +0800
Message-Id: <1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <ktime_ms_delta>
References: <ktime_ms_delta>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a reusable time difference function which returns the
difference in millisecond, as often used in some driver code, e.g.
mtd/test, media/rc, etc.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 include/linux/ktime.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index c9d645a..891ea92 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -186,6 +186,11 @@ static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
        return ktime_to_us(ktime_sub(later, earlier));
 }
 
+static inline s64 ktime_ms_delta(const ktime_t later, const ktime_t earlier)
+{
+	return ktime_to_ms(ktime_sub(later, earlier));
+}
+
 static inline ktime_t ktime_add_us(const ktime_t kt, const u64 usec)
 {
 	return ktime_add_ns(kt, usec * NSEC_PER_USEC);
-- 
1.7.9.5


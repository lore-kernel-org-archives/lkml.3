Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLRLxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:53:02 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64573 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaLRLw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:52:58 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: m.chehab@samsung.com, david@hardeman.nu, uli-lirc@uli-eckhardt.de,
        hans.verkuil@cisco.com, julia.lawall@lip6.fr, himangi774@gmail.com,
        khoroshilov@ispras.ru, joe@perches.com, dborkman@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de, davem@davemloft.net,
        dwmw2@infradead.org, computersforpeace@gmail.com, arnd@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, zhang.lyra@gmail.com
Subject: [PATCH 1/3] ktime.h: Introduce ktime_ms_delta
Date: Thu, 18 Dec 2014 19:52:00 +0800
Message-Id: <1418903522-19137-2-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
References: <ktime-mtd-rc-v1>
 <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a reusable time difference function which returns
the difference in millisecond, as often used in some driver code, e.g.
mtd/test, media/rc, etc.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Acked-by: Arnd Bergmann <arnd@linaro.org>
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


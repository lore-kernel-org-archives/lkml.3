Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3EFOHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:07:18 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:37071
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab3EFOHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:07:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 15
X-BigFish: VS15(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah132dlzz8275bh8275dh8275chz2dh1eh2a8h668h839hf0ah107ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14afh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh4a8s1155h)
From: <y@shlinux1.ap.freescale.net>
To: <linux-kernel@vger.kernel.org>
CC: <davem@davemloft.net>, <dborkman@redhat.com>, <tglx@linutronix.de>,
        <john.stultz@linaro.org>, <liu.y.victor@gmail.com>,
        Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] ktime: Use macro NSEC_PER_USEC instead of a magic number
Date: Mon, 6 May 2013 20:42:15 +0800
Message-ID: <1367844135-31383-1-git-send-email-y>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ying <Ying.Liu@freescale.com>

We've got the macro NSEC_PER_USEC defined in header file
include/linux/time.h. To make the code decent, this patch
replaces the magic number 1000 to convert bewteen a time
value in microseconds and one in nanoseconds with the
macro NSEC_PER_USEC.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 include/linux/ktime.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index bbca128..5de963d 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -229,7 +229,8 @@ static inline ktime_t timespec_to_ktime(const struct timespec ts)
 static inline ktime_t timeval_to_ktime(const struct timeval tv)
 {
 	return (ktime_t) { .tv = { .sec = (s32)tv.tv_sec,
-				   .nsec = (s32)tv.tv_usec * 1000 } };
+				   .nsec = (s32)tv.tv_usec *
+					   (s32)NSEC_PER_USEC} };
 }
 
 /**
@@ -320,12 +321,12 @@ static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
 
 static inline ktime_t ktime_add_us(const ktime_t kt, const u64 usec)
 {
-	return ktime_add_ns(kt, usec * 1000);
+	return ktime_add_ns(kt, usec * NSEC_PER_USEC);
 }
 
 static inline ktime_t ktime_sub_us(const ktime_t kt, const u64 usec)
 {
-	return ktime_sub_ns(kt, usec * 1000);
+	return ktime_sub_ns(kt, usec * NSEC_PER_USEC);
 }
 
 extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
-- 
1.7.1



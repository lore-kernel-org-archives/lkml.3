Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbbAWKs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:48:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbAWKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:48:54 -0500
Date: Fri, 23 Jan 2015 02:48:39 -0800
From: tip-bot for Chunyan Zhang <tipbot@zytor.com>
Message-ID: <tip-41fbf3b39d5eca01527338b4d0ee15ee1ae1023c@git.kernel.org>
Cc: arnd@linaro.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        zhang.chunyan@linaro.org, mingo@kernel.org, tglx@linutronix.de
Reply-To: arnd@linaro.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        zhang.chunyan@linaro.org, tglx@linutronix.de, mingo@kernel.org
In-Reply-To: <1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org>
References: <1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ktime.h: Introduce ktime_ms_delta
Git-Commit-ID: 41fbf3b39d5eca01527338b4d0ee15ee1ae1023c
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

Commit-ID:  41fbf3b39d5eca01527338b4d0ee15ee1ae1023c
Gitweb:     http://git.kernel.org/tip/41fbf3b39d5eca01527338b4d0ee15ee1ae1023c
Author:     Chunyan Zhang <zhang.chunyan@linaro.org>
AuthorDate: Wed, 17 Dec 2014 13:11:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 11:47:15 +0100

ktime.h: Introduce ktime_ms_delta

This patch adds a reusable time difference function which returns the
difference in millisecond, as often used in some driver code, e.g.
mtd/test, media/rc, etc.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Acked-by: Arnd Bergmann <arnd@linaro.org>
Cc: zhang.lyra@gmail.com
Cc: davem@davemloft.net
Cc: john.stultz@linaro.org
Cc: dborkman@redhat.com
Link: http://lkml.kernel.org/r/1418793095-18780-1-git-send-email-zhang.chunyan@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/ktime.h | 5 +++++
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

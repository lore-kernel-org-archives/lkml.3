Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3EPNrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab3EPNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:47:52 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ktime: minor: ktime_to_timespec_cond: add __must_check prefix
Date: Thu, 16 May 2013 15:47:49 +0200
Message-Id: <1368712069-522-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is currently mainly used in the networking code and
if others start using it, they must check the result, otherwise
it cannot be determined if the timespec conversion suceeded.
Currently no user lacks this check, but make future users aware of
a possible misusage.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/linux/ktime.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index bbca128..cededfd 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -338,7 +338,8 @@ extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
  *
  * Returns true if there was a successful conversion, false if kt was 0.
  */
-static inline bool ktime_to_timespec_cond(const ktime_t kt, struct timespec *ts)
+static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
+						       struct timespec *ts)
 {
 	if (kt.tv64) {
 		*ts = ktime_to_timespec(kt);
-- 
1.7.11.7


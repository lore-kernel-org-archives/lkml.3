Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaE1O3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:29:06 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:55419 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaE1O3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:29:04 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fence: Use smp_mb__before_atomic()
Date: Wed, 28 May 2014 16:26:32 +0200
Message-Id: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
functions in favour of the unified smp_mb__{before,after}_atomic().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/fence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/fence.c b/drivers/base/fence.c
index f780f9b3d418..74d1f7bcb467 100644
--- a/drivers/base/fence.c
+++ b/drivers/base/fence.c
@@ -65,7 +65,7 @@ int __fence_signal(struct fence *fence)
 
 	if (!ktime_to_ns(fence->timestamp)) {
 		fence->timestamp = ktime_get();
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 	}
 
 	if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
@@ -105,7 +105,7 @@ int fence_signal(struct fence *fence)
 
 	if (!ktime_to_ns(fence->timestamp)) {
 		fence->timestamp = ktime_get();
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 	}
 
 	if (test_and_set_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
-- 
1.9.2


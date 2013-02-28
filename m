Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3B1O7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:59:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab3B1OuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 108/139] drm/i915: Set i9xx sdvo clock limits according to specifications
Date: Thu, 28 Feb 2013 14:44:18 +0000
Message-Id: <1362062689-2567-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit 4f7dfb6788dd022446847fbbfbe45e13bedb5be2 upstream.

The Intel PRM says the M1 and M2 divisors must be in the range of 10-20 and 5-9.
Since we do all calculations based on them being register values (which are
subtracted by 2) we need to specify them accordingly.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56359
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index bff2719..78e4274 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -141,8 +141,8 @@ static const intel_limit_t intel_limits_i9xx_sdvo = {
 	.vco = { .min = 1400000, .max = 2800000 },
 	.n = { .min = 1, .max = 6 },
 	.m = { .min = 70, .max = 120 },
-	.m1 = { .min = 10, .max = 22 },
-	.m2 = { .min = 5, .max = 9 },
+	.m1 = { .min = 8, .max = 18 },
+	.m2 = { .min = 3, .max = 7 },
 	.p = { .min = 5, .max = 80 },
 	.p1 = { .min = 1, .max = 8 },
 	.p2 = { .dot_limit = 200000,
-- 
1.8.1.2


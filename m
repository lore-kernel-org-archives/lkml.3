Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab3B0ASQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:18:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402Ab3B0AJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 54/86] drm/i915: Set i9xx sdvo clock limits according to specifications
Date: Tue, 26 Feb 2013 16:08:02 -0800
Message-Id: <20130226235918.530615135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -142,8 +142,8 @@ static const intel_limit_t intel_limits_
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



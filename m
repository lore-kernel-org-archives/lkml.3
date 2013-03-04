Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3CDDnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3CDDnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:47 -0500
Message-Id: <20130304033715.655904985@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 082/153] drm/i915: Set i9xx sdvo clock limits according to specifications
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -138,8 +138,8 @@ static const intel_limit_t intel_limits_
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



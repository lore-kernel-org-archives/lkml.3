Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3CDELh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:11:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862Ab3CDDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:01 -0500
Message-Id: <20130304033719.200264575@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 118/153] drm/radeon/evergreen+: wait for the MC to settle after MC  blackout
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ed39fadd6df01095378e499fac3674883f16b853 upstream.

Some chips seem to need a little delay after blacking out
the MC before the requests actually stop.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56139
https://bugs.freedesktop.org/show_bug.cgi?id=57567

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1137,6 +1137,8 @@ void evergreen_mc_stop(struct radeon_dev
 		blackout &= ~BLACKOUT_MODE_MASK;
 		WREG32(MC_SHARED_BLACKOUT_CNTL, blackout | 1);
 	}
+	/* wait for the MC to settle */
+	udelay(100);
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaHDQyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:54:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56653 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.984874744@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 46/94] drm/radeon/dp: return -EIO for flags not zero case
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f6be5e64500abbba44e191e1ca0f3366c7d0291b upstream.

If there are error flags in the aux transaction return
-EIO rather than -EBUSY.  -EIO restarts the whole transaction
while -EBUSY jus retries.  Fixes problematic aux transfers.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=80684

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: error code is returned directly here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -89,7 +89,7 @@ static int radeon_process_aux_ch(struct
 	/* flags not zero */
 	if (args.v1.ucReplyStatus == 2) {
 		DRM_DEBUG_KMS("dp_aux_ch flags not zero\n");
-		return -EBUSY;
+		return -EIO;
 	}
 
 	/* error */


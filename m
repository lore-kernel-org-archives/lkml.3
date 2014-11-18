Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaKROKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:10:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbaKROKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 194/206] drm/radeon/dpm: disable ulv support on SI
Date: Tue, 18 Nov 2014 15:09:09 +0100
Message-Id: <e217f8d2008f3c4f6695aabb099171e3a7176186.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6fa455935ab956248b165f150ec6ae9106210077 upstream.

Causes problems on some boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=82889

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 83895f2d16c6..f5cdc865752a 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -6220,7 +6220,7 @@ static void si_parse_pplib_clock_info(struct radeon_device *rdev,
 	if ((rps->class2 & ATOM_PPLIB_CLASSIFICATION2_ULV) &&
 	    index == 0) {
 		/* XXX disable for A0 tahiti */
-		si_pi->ulv.supported = true;
+		si_pi->ulv.supported = false;
 		si_pi->ulv.pl = *pl;
 		si_pi->ulv.one_pcie_lane_in_ulv = false;
 		si_pi->ulv.volt_change_delay = SISLANDS_ULVVOLTAGECHANGEDELAY_DFLT;
-- 
2.1.3


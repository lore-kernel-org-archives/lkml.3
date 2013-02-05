Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab3BEWLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab3BEWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 53/93] drm/radeon: fix cursor corruption on DCE6 and newer
Date: Tue,  5 Feb 2013 20:06:42 -0200
Message-Id: <1360102042-10732-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit e521a29014794d139cca46396d1af8faf1295a26 upstream.

Aruba and newer gpu does not need the avivo cursor work around,
quite the opposite this work around lead to corruption.

agd5f: check DCE6 rather than ARUBA since the issue is DCE
version specific rather than family specific.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cursor.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cursor.c b/drivers/gpu/drm/radeon/radeon_cursor.c
index 711e95a..8fb6f41 100644
--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -238,7 +238,8 @@ int radeon_crtc_cursor_move(struct drm_crtc *crtc,
 		y = 0;
 	}
 
-	if (ASIC_IS_AVIVO(rdev)) {
+	/* fixed on DCE6 and newer */
+	if (ASIC_IS_AVIVO(rdev) && !ASIC_IS_DCE6(rdev)) {
 		int i = 0;
 		struct drm_crtc *crtc_p;
 
-- 
1.7.9.5


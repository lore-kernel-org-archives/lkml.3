Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292Ab3BAKtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:49:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:39050 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062Ab3BAKtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:49:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 09/33] drm/radeon: fix cursor corruption on DCE6 and newer
Date: Fri,  1 Feb 2013 11:49:14 +0100
Message-Id: <20130201104725.309104651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit e521a29014794d139cca46396d1af8faf1295a26 upstream.

Aruba and newer gpu does not need the avivo cursor work around,
quite the opposite this work around lead to corruption.

agd5f: check DCE6 rather than ARUBA since the issue is DCE
version specific rather than family specific.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cursor.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -238,7 +238,8 @@ int radeon_crtc_cursor_move(struct drm_c
 		y = 0;
 	}
 
-	if (ASIC_IS_AVIVO(rdev)) {
+	/* fixed on DCE6 and newer */
+	if (ASIC_IS_AVIVO(rdev) && !ASIC_IS_DCE6(rdev)) {
 		int i = 0;
 		struct drm_crtc *crtc_p;
 



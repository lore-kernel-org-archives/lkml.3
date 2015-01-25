Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbbAYS7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:59:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbbAYSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 037/183] drm/radeon: fix sad_count check for dce3
Date: Sun, 25 Jan 2015 10:05:59 -0800
Message-Id: <20150125180811.792816671@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5665c3ebe5ee8a2c516925461f7214ba59c2e6d7 upstream.

Make it consistent with the sad code for other asics to deal
with monitors that don't report sads.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=89461

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/dce3_1_afmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -103,7 +103,7 @@ static void dce3_2_afmt_write_sad_regs(s
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}



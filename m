Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaAOWCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:02:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaAOWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:01:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 073/166] drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook
Date: Wed, 15 Jan 2014 13:51:27 -0800
Message-Id: <1389822780-4729-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit 49d45a31b71d7d9da74485922bdb63faf3dc9684 upstream.

This bug in EDID was exposed by:

commit eccea7920cfb009c2fa40e9ecdce8c36f61cab66
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Mon Mar 26 15:12:54 2012 -0400

    drm/radeon/kms: improve bpc handling (v2)

Which resulted in kind of regression in 3.5. This fixes
https://bugs.freedesktop.org/show_bug.cgi?id=70934

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 60d6b35..559f49b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -68,6 +68,8 @@
 #define EDID_QUIRK_DETAILED_SYNC_PP		(1 << 6)
 /* Force reduced-blanking timings for detailed modes */
 #define EDID_QUIRK_FORCE_REDUCED_BLANKING	(1 << 7)
+/* Force 8bpc */
+#define EDID_QUIRK_FORCE_8BPC			(1 << 8)
 
 struct detailed_mode_closure {
 	struct drm_connector *connector;
@@ -128,6 +130,9 @@ static struct edid_quirk {
 
 	/* Medion MD 30217 PG */
 	{ "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
+
+	/* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
+	{ "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
 };
 
 /*** DDC fetch and block validation ***/
@@ -2034,6 +2039,9 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 
 	drm_add_display_info(edid, &connector->display_info);
 
+	if (quirks & EDID_QUIRK_FORCE_8BPC)
+		connector->display_info.bpc = 8;
+
 	return num_modes;
 }
 EXPORT_SYMBOL(drm_add_edid_modes);
-- 
1.8.3.2


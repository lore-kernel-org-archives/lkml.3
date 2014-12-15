Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaLOTfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:35:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaLOTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 86/96] drm/radeon: initialize sadb to NULL in the audio code
Date: Mon, 15 Dec 2014 11:26:46 -0800
Message-Id: <1418671616-25482-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 83d04c39f9048807a8500e575ae3f1718a3f45bb upstream.

Fixes kfree of the sadb buffer when it's NULL.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
BugLink: http://bugs.launchpad.net/bugs/1402714
(backported from commit 83d04c39f9048807a8500e575ae3f1718a3f45bb)
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/dce6_afmt.c      | 2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index 3483828..a6e5151 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -155,7 +155,7 @@ void dce6_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 offset, tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	if (!dig || !dig->afmt || !dig->afmt->pin)
diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 738c1ec..a10879d 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -102,7 +102,7 @@ static void dce4_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	list_for_each_entry(connector, &encoder->dev->mode_config.connector_list, head) {
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index b7d3ecb..bae30c6 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -326,7 +326,7 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	/* XXX: setting this register causes hangs on some asics */
-- 
1.9.1


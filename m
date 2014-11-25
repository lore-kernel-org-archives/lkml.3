Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaKYKvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:51:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaKYKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 234/254] drm/radeon: initialize sadb to NULL in the audio code
Date: Tue, 25 Nov 2014 10:39:44 +0000
Message-Id: <1416912004-5928-235-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 83d04c39f9048807a8500e575ae3f1718a3f45bb upstream.

Fixes kfree of the sadb buffer when it's NULL.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/dce3_1_afmt.c    | 2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c      | 2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index 71f4d26669cd..13a27d971d35 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -32,7 +32,7 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	list_for_each_entry(connector, &encoder->dev->mode_config.connector_list, head) {
diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index ee5da3b56fbf..ed131d7422dc 100644
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
index d9c8bb9559a9..9343ebc74480 100644
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
-- 
2.1.0


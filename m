Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaLEW4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:56:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaLEW4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 114/122] drm/radeon: initialize sadb to NULL in the audio code
Date: Fri,  5 Dec 2014 14:44:48 -0800
Message-Id: <20141205223323.308418486@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 83d04c39f9048807a8500e575ae3f1718a3f45bb upstream.

Fixes kfree of the sadb buffer when it's NULL.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/dce3_1_afmt.c    |    2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c      |    2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -32,7 +32,7 @@ static void dce3_2_afmt_write_speaker_al
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	list_for_each_entry(connector, &encoder->dev->mode_config.connector_list, head) {
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -155,7 +155,7 @@ void dce6_afmt_write_speaker_allocation(
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 offset, tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	if (!dig || !dig->afmt || !dig->afmt->pin)
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -102,7 +102,7 @@ static void dce4_afmt_write_speaker_allo
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector = NULL;
 	u32 tmp;
-	u8 *sadb;
+	u8 *sadb = NULL;
 	int sad_count;
 
 	list_for_each_entry(connector, &encoder->dev->mode_config.connector_list, head) {



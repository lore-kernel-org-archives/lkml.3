Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbbABUwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:52:03 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:36612 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbABUwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:52:02 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: armada: armada_output:  Remove some unused functions
Date: Fri,  2 Jan 2015 21:55:02 +0100
Message-Id: <1420232102-2935-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
armada_drm_encoder_mode_fixup() armada_drm_encoder_commit() armada_drm_encoder_prepare()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/armada/armada_output.c |   16 ----------------
 drivers/gpu/drm/armada/armada_output.h |    6 ------
 2 files changed, 22 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_output.c b/drivers/gpu/drm/armada/armada_output.c
index abbc309..5a98231 100644
--- a/drivers/gpu/drm/armada/armada_output.c
+++ b/drivers/gpu/drm/armada/armada_output.c
@@ -72,22 +72,6 @@ static const struct drm_connector_funcs armada_drm_conn_funcs = {
 	.set_property	= armada_drm_connector_set_property,
 };
 
-void armada_drm_encoder_prepare(struct drm_encoder *encoder)
-{
-	encoder_helper_funcs(encoder)->dpms(encoder, DRM_MODE_DPMS_OFF);
-}
-
-void armada_drm_encoder_commit(struct drm_encoder *encoder)
-{
-	encoder_helper_funcs(encoder)->dpms(encoder, DRM_MODE_DPMS_ON);
-}
-
-bool armada_drm_encoder_mode_fixup(struct drm_encoder *encoder,
-	const struct drm_display_mode *mode, struct drm_display_mode *adjusted)
-{
-	return true;
-}
-
 /* Shouldn't this be a generic helper function? */
 int armada_drm_slave_encoder_mode_valid(struct drm_connector *conn,
 	struct drm_display_mode *mode)
diff --git a/drivers/gpu/drm/armada/armada_output.h b/drivers/gpu/drm/armada/armada_output.h
index 4126d43..d3a6ce7 100644
--- a/drivers/gpu/drm/armada/armada_output.h
+++ b/drivers/gpu/drm/armada/armada_output.h
@@ -21,12 +21,6 @@ struct armada_output_type {
 
 struct drm_encoder *armada_drm_connector_encoder(struct drm_connector *conn);
 
-void armada_drm_encoder_prepare(struct drm_encoder *encoder);
-void armada_drm_encoder_commit(struct drm_encoder *encoder);
-
-bool armada_drm_encoder_mode_fixup(struct drm_encoder *encoder,
-	const struct drm_display_mode *mode, struct drm_display_mode *adj);
-
 int armada_drm_slave_encoder_mode_valid(struct drm_connector *conn,
 	struct drm_display_mode *mode);
 
-- 
1.7.10.4


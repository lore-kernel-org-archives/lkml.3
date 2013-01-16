Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab3APQMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:12:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3APQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 221/222] Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
Date: Wed, 16 Jan 2013 13:57:01 -0200
Message-Id: <1358351822-7675-222-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 48e858340dae43189a4e55647f6eac736766f828 upstream.

This reverts commit 9756fe38d10b2bf90c81dc4d2f17d5632e135364.

The bogus lvds output is actually a lvds->hdmi bridge, which we don't
really support. But unconditionally disabling it breaks some existing
setups.

Reported-by: John Tapsell <johnflux@gmail.com>
References: http://permalink.gmane.org/gmane.comp.freedesktop.xorg.drivers.intel/17237
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 37d7243..183a8d0 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -780,14 +780,6 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "ZOTAC ZBOXSD-ID12/ID13",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ZOTAC"),
-			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
-		},
-	},
-	{
-		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Gigabyte GA-D525TUD",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
-- 
1.7.9.5


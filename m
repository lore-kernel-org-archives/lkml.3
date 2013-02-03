Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3BCO60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34601 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044Ab3BCO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:22 -0500
Message-Id: <20130203144654.541758403@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Tapsell <johnflux@gmail.com>
Subject: [ 119/128] Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b9a660a..17aee74 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -776,14 +776,6 @@ static const struct dmi_system_id intel_no_lvds[] = {
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



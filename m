Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3B1Ot5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab3B1Oty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 098/139] Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
Date: Thu, 28 Feb 2013 14:44:08 +0000
Message-Id: <1362062689-2567-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit db3985e5ca8f50fc17606855ba394783d11683a5 upstream.

This reverts commit 6f33814bd4d9cfe76033a31b1c0c76c960cd8e4b.

The quirk cause a regression, and it looks like the original bug was
simply a lack of FIFO bandwidth on the i915G of the reporter. Which
should eventually be fixed as soon as we get around to implemented
DSPARB FIFO reassignment on gen 3.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=52281
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b7ee230..a8743c3 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -87,9 +87,6 @@ static struct edid_quirk {
 	int product_id;
 	u32 quirks;
 } edid_quirk_list[] = {
-	/* ASUS VW222S */
-	{ "ACI", 0x22a2, EDID_QUIRK_FORCE_REDUCED_BLANKING },
-
 	/* Acer AL1706 */
 	{ "ACR", 44358, EDID_QUIRK_PREFER_LARGE_60 },
 	/* Acer F51 */
-- 
1.8.1.2


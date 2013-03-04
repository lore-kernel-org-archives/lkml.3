Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3CDDxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:53:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab3CDDod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:33 -0500
Message-Id: <20130304033712.440649403@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 049/153] Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_edid.c |    3 ---
 1 file changed, 3 deletions(-)

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



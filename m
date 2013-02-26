Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab3B0BCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:02:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3BZX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 076/150] Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
Date: Tue, 26 Feb 2013 15:55:33 -0800
Message-Id: <20130226235532.060632680@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



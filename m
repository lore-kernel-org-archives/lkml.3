Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3CZWoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3CZWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 36/98] Revert "drm/i915: try to train DP even harder"
Date: Tue, 26 Mar 2013 15:42:25 -0700
Message-Id: <20130326224246.189369346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3b4f819d5eac94ba8fe5e8c061f6dabfe8d7b22c upstream.

This reverts commit 0d71068835e2610576d369d6d4cbf90e0f802a71.

Not only that the commit introduces a bogus check (voltage_tries == 5
will never meet at the inserted code path), it brings the i915 driver
into an endless dp-train loop on HP Z1 desktop machine with IVY+eDP.

At least reverting this commit recovers the framebuffer (but X is
still broken by other reasons...)

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1850,7 +1850,7 @@ intel_dp_start_link_train(struct intel_d
 		for (i = 0; i < intel_dp->lane_count; i++)
 			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) == 0)
 				break;
-		if (i == intel_dp->lane_count && voltage_tries == 5) {
+		if (i == intel_dp->lane_count) {
 			++loop_tries;
 			if (loop_tries == 5) {
 				DRM_DEBUG_KMS("too many full retries, give up\n");



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949Ab3DKUfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:35:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3DKU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:10 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XiSSSh9d0IAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RD0tcvr7_xAA:10 a=VwQbUJbxAAAA:8 a=FGWJaHgTAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202551.574326507@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 033/171 ] Revert "drm/i915: try to train DP even harder"
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0033-Revert-drm-i915-try-to-train-DP-even-harder.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3b4f819d5eac94ba8fe5e8c061f6dabfe8d7b22c ]

This reverts commit 0d71068835e2610576d369d6d4cbf90e0f802a71.

Not only that the commit introduces a bogus check (voltage_tries == 5
will never meet at the inserted code path), it brings the i915 driver
into an endless dp-train loop on HP Z1 desktop machine with IVY+eDP.

At least reverting this commit recovers the framebuffer (but X is
still broken by other reasons...)

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index ace757a..82e5e0d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1771,7 +1771,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		for (i = 0; i < intel_dp->lane_count; i++)
 			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) == 0)
 				break;
-		if (i == intel_dp->lane_count && voltage_tries == 5) {
+		if (i == intel_dp->lane_count) {
 			++loop_tries;
 			if (loop_tries == 5) {
 				DRM_DEBUG_KMS("too many full retries, give up\n");
-- 
1.7.10.4



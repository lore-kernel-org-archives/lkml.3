Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaGZTZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:25:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaGZTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.15 089/109] Revert "drm/i915: reverse dp link param selection, prefer fast over wide again"
Date: Sat, 26 Jul 2014 12:02:51 -0700
Message-Id: <20140726190226.538130544@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit c6930992948adf0f8fc1f6ff1da51c5002a2cf95 upstream.

This reverts commit 38aecea0ccbb909d635619cba22f1891e589b434.

This breaks Haswell Thinkpad + Lenovo dock in SST mode with a HDMI monitor attached.

Before this we can 1920x1200 mode, after this we only ever get 1024x768, and
a lot of deferring.

This didn't revert clean, but this should be fine.

bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1117008
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -833,8 +833,8 @@ intel_dp_compute_config(struct intel_enc
 		mode_rate = intel_dp_link_required(adjusted_mode->crtc_clock,
 						   bpp);
 
-		for (lane_count = min_lane_count; lane_count <= max_lane_count; lane_count <<= 1) {
-			for (clock = min_clock; clock <= max_clock; clock++) {
+		for (clock = min_clock; clock <= max_clock; clock++) {
+			for (lane_count = min_lane_count; lane_count <= max_lane_count; lane_count <<= 1) {
 				link_clock = drm_dp_bw_code_to_link_rate(bws[clock]);
 				link_avail = intel_dp_max_data_rate(link_clock,
 								    lane_count);



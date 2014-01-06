Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaAFPDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:03:04 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63986 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:03:03 -0500
Date: Mon, 6 Jan 2014 20:32:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 08/85] drivers: gpu: Mark function as static in cdv_intel_dp.c
Message-ID: <9707c877b8dace786fad32b3fb3b262cf97a02aa.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function cdv_intel_fixed_panel_mode() as static in
drm/gma500/cdv_intel_dp.c because it is not used outside this file.

This eliminates the following warning in drm/gma500/cdv_intel_dp.c:
drivers/gpu/drm/gma500/cdv_intel_dp.c:680:6: warning: no previous prototype for ‘cdv_intel_fixed_panel_mode’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/gma500/cdv_intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
index f88a181..36975bd 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -677,7 +677,7 @@ cdv_intel_dp_i2c_init(struct gma_connector *connector,
 	return ret;
 }
 
-void cdv_intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
+static void cdv_intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
 	struct drm_display_mode *adjusted_mode)
 {
 	adjusted_mode->hdisplay = fixed_mode->hdisplay;
-- 
1.7.9.5


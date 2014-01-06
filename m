Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaAFPsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:48:14 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43451 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAFPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:48:12 -0500
Date: Mon, 6 Jan 2014 21:18:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pierre Ossman <pierre@ossman.eu>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 40/85] drivers: gpu: Mark function as static in r600_hdmi.c
Message-ID: <f88fb6382eaea318caad1a6bdfc02c4fc5cd1d9a.1389018325.git.rashika.kheria@gmail.com>
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

Mark function r600_audio_set_dto() as static in drm/radeon/r600_hdmi.c
because it is not used outside this file.

This eliminates the following warning in drm/radeon/r600_hdmi.c:
drivers/gpu/drm/radeon/r600_hdmi.c:253:6: warning: no previous prototype for ‘r600_audio_set_dto’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/r600_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index b7d3ecb..3016fc1 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -250,7 +250,7 @@ static void r600_hdmi_audio_workaround(struct drm_encoder *encoder)
 		 value, ~HDMI0_AUDIO_TEST_EN);
 }
 
-void r600_audio_set_dto(struct drm_encoder *encoder, u32 clock)
+static void r600_audio_set_dto(struct drm_encoder *encoder, u32 clock)
 {
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbaAFWkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:40:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807AbaAFWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 042/129] drm/radeon: add missing display tiling setup for oland
Date: Mon,  6 Jan 2014 14:37:51 -0800
Message-Id: <20140106223900.804123162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 227ae10f17a5f2fd1307b7e582b603ef7bbb7e97 upstream.

Fixes improperly set up display params for 2D tiling on
oland.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1176,7 +1176,9 @@ static int dce4_crtc_do_set_base(struct
 	if ((rdev->family == CHIP_TAHITI) ||
 	    (rdev->family == CHIP_PITCAIRN))
 		fb_format |= SI_GRPH_PIPE_CONFIG(SI_ADDR_SURF_P8_32x32_8x16);
-	else if (rdev->family == CHIP_VERDE)
+	else if ((rdev->family == CHIP_VERDE) ||
+		 (rdev->family == CHIP_OLAND) ||
+		 (rdev->family == CHIP_HAINAN)) /* for completeness.  HAINAN has no display hw */
 		fb_format |= SI_GRPH_PIPE_CONFIG(SI_ADDR_SURF_P4_8x16);
 
 	switch (radeon_crtc->crtc_id) {



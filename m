Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaGHAnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaGGXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 28/94] drm/radeon: fix typo in radeon_connector_is_dp12_capable()
Date: Mon,  7 Jul 2014 16:57:18 -0700
Message-Id: <20140707235757.624067047@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit af5d36539dfe043f1cf0f8b7334d6bb12cd14e75 upstream.

We were checking the ext clock rather than the display clock.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1402,7 +1402,7 @@ bool radeon_connector_is_dp12_capable(st
 	struct radeon_device *rdev = dev->dev_private;
 
 	if (ASIC_IS_DCE5(rdev) &&
-	    (rdev->clock.dp_extclk >= 53900) &&
+	    (rdev->clock.default_dispclk >= 53900) &&
 	    radeon_connector_encoder_is_hbr2(connector)) {
 		return true;
 	}



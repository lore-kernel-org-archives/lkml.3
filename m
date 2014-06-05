Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaFEEhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:37:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFEEVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 161/214] drm/radeon: fix amd afusion gpu setup aka sumo v2
Date: Wed,  4 Jun 2014 21:18:44 -0700
Message-Id: <20140605041701.232441601@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit bd25f0783dc3fb72e1e2779c2b99b2d34b67fa8a upstream.

Set the proper number of tile pipe that should be a multiple of
pipe depending on the number of se engine.

Fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56405
https://bugs.freedesktop.org/show_bug.cgi?id=56720

v2: Don't change sumo2

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: don't define/use *_GB_ADDR_CONFIG_GOLDEN]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1874,7 +1874,7 @@ static void evergreen_gpu_init(struct ra
 	case CHIP_SUMO:
 		rdev->config.evergreen.num_ses = 1;
 		rdev->config.evergreen.max_pipes = 4;
-		rdev->config.evergreen.max_tile_pipes = 2;
+		rdev->config.evergreen.max_tile_pipes = 4;
 		if (rdev->pdev->device == 0x9648)
 			rdev->config.evergreen.max_simds = 3;
 		else if ((rdev->pdev->device == 0x9647) ||
@@ -1963,7 +1963,7 @@ static void evergreen_gpu_init(struct ra
 		break;
 	case CHIP_CAICOS:
 		rdev->config.evergreen.num_ses = 1;
-		rdev->config.evergreen.max_pipes = 4;
+		rdev->config.evergreen.max_pipes = 2;
 		rdev->config.evergreen.max_tile_pipes = 2;
 		rdev->config.evergreen.max_simds = 2;
 		rdev->config.evergreen.max_backends = 1 * rdev->config.evergreen.num_ses;



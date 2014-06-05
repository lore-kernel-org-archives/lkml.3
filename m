Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaFEEcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:32:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaFEEWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 178/214] drm/radeon: cleanup properly if mmio mapping fails
Date: Wed,  4 Jun 2014 21:19:01 -0700
Message-Id: <20140605041703.390842404@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0cd9cb76ae26a19df21abc6f94f5fff141e689c7 upstream.

If we fail to map the mmio BAR, skip driver tear down
that requires mmio.

Should fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56541

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -39,8 +39,12 @@ int radeon_driver_unload_kms(struct drm_
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;



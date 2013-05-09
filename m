Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab3EIWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:47:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3EIWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 58/73] drm/radeon: cleanup properly if mmio mapping fails
Date: Thu,  9 May 2013 15:32:21 -0700
Message-Id: <20130509222804.204991021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0cd9cb76ae26a19df21abc6f94f5fff141e689c7 upstream.

If we fail to map the mmio BAR, skip driver tear down
that requires mmio.

Should fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56541

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -50,9 +50,13 @@ int radeon_driver_unload_kms(struct drm_
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_acpi_fini(rdev);
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;



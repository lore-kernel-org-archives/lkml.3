Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3HUSbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:31:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59548 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3HUSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:31:51 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: jglisse@redhat.com
Cc: linux-kernel@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Radeon driver: fix memory leak
Date: Wed, 21 Aug 2013 19:31:31 +0100
Message-Id: <1377109891-14503-1-git-send-email-fdmanana@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing a struct radeon_device, its member iio was
not being freed, resulting in a memory leak.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 63398ae..e57efb4 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -912,6 +912,7 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
 	}
+	kfree(rdev->mode_info.atom_context->iio);
 	kfree(rdev->mode_info.atom_context);
 	rdev->mode_info.atom_context = NULL;
 	kfree(rdev->mode_info.atom_card_info);
-- 
1.7.9.5


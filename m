Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3HUSyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:54:09 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36579 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3HUSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:54:08 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: jglisse@redhat.com
Cc: linux-kernel@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Radeon driver: fix memory leak
Date: Wed, 21 Aug 2013 19:53:47 +0100
Message-Id: <1377111227-15947-1-git-send-email-fdmanana@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377109891-14503-1-git-send-email-fdmanana@gmail.com>
References: <1377109891-14503-1-git-send-email-fdmanana@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing a struct radeon_device, its member iio was
not being freed, resulting in a memory leak.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: put kfree() call inside if statement.

 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 63398ae..5d94d5e 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -911,6 +911,7 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 {
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
+		kfree(rdev->mode_info.atom_context->iio);
 	}
 	kfree(rdev->mode_info.atom_context);
 	rdev->mode_info.atom_context = NULL;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3APAan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:30:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:41808 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864Ab3AOW3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 072/221] drm/radeon: restore modeset late in GPU reset path
Date: Tue, 15 Jan 2013 10:49:59 -0800
Message-Id: <20130115185003.259956162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit d3493574e267c203836bfdcb9c58d8af46fc0da1 upstream.

Modeset path seems to conflict sometimes with the memory management
leading to kernel deadlock. This move modesetting reset after GPU
acceleration reset.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1337,7 +1337,6 @@ retry:
 	}
 
 	radeon_restore_bios_scratch_regs(rdev);
-	drm_helper_resume_force_mode(rdev->ddev);
 
 	if (!r) {
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
@@ -1362,6 +1361,8 @@ retry:
 		}
 	}
 
+	drm_helper_resume_force_mode(rdev->ddev);
+
 	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
 	if (r) {
 		/* bad news, how to tell it to userspace ? */



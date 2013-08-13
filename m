Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3HMGnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:43:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab3HMGd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 44/60] drm/radeon: stop sending invalid UVD destroy msg
Date: Mon, 12 Aug 2013 23:34:11 -0700
Message-Id: <20130813063337.867736235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 641a00593f7d07eab778fbabf546fb68fff3d5ce upstream.

We also need to check the handle.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -218,8 +218,8 @@ void radeon_uvd_free_handles(struct rade
 {
 	int i, r;
 	for (i = 0; i < RADEON_MAX_UVD_HANDLES; ++i) {
-		if (rdev->uvd.filp[i] == filp) {
-			uint32_t handle = atomic_read(&rdev->uvd.handles[i]);
+		uint32_t handle = atomic_read(&rdev->uvd.handles[i]);
+		if (handle != 0 && rdev->uvd.filp[i] == filp) {
 			struct radeon_fence *fence;
 
 			r = radeon_uvd_get_destroy_msg(rdev,



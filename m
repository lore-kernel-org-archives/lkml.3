Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161594Ab3LFNCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161578Ab3LFNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/272] drm/radeon: activate UVD clocks before sending the destroy msg
Date: Fri,  6 Dec 2013 12:57:09 +0000
Message-Id: <1386334761-25517-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit c154a76311293f9671439286834aa325b7ef59fe upstream.

Make sure the UVD clocks are still active before sending
the destroy message, otherwise the hw might hang.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_uvd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index b79f4f5..a951ac0 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -239,6 +239,8 @@ void radeon_uvd_free_handles(struct radeon_device *rdev, struct drm_file *filp)
 		if (handle != 0 && rdev->uvd.filp[i] == filp) {
 			struct radeon_fence *fence;
 
+			radeon_uvd_note_usage(rdev);
+
 			r = radeon_uvd_get_destroy_msg(rdev,
 				R600_RING_TYPE_UVD_INDEX, handle, &fence);
 			if (r) {
-- 
1.8.3.2


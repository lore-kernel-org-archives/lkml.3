Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3LBTuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:50:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3LBTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 134/212] drm/radeon: activate UVD clocks before sending the destroy msg
Date: Mon,  2 Dec 2013 11:15:25 -0800
Message-Id: <20131202191301.927229253@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit c154a76311293f9671439286834aa325b7ef59fe upstream.

Make sure the UVD clocks are still active before sending
the destroy message, otherwise the hw might hang.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_uvd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -240,6 +240,8 @@ void radeon_uvd_free_handles(struct rade
 		if (handle != 0 && rdev->uvd.filp[i] == filp) {
 			struct radeon_fence *fence;
 
+			radeon_uvd_note_usage(rdev);
+
 			r = radeon_uvd_get_destroy_msg(rdev,
 				R600_RING_TYPE_UVD_INDEX, handle, &fence);
 			if (r) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3HBKls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:41:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030408Ab3HBKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frank Huang <FrankR.Huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 67/99] drm/radeon: fix UVD fence emit
Date: Fri,  2 Aug 2013 18:08:20 +0800
Message-Id: <20130802100235.373047601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit c9a6ca4abd5f1978ef15b3ece3474f4372ae5fe7 upstream.

Currently doesn't matter cause we allocate the fence in the
lower 265MB anyway.

Reported-by: Frank Huang <FrankR.Huang@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2986,7 +2986,7 @@ void r600_uvd_fence_emit(struct radeon_d
 			 struct radeon_fence *fence)
 {
 	struct radeon_ring *ring = &rdev->ring[fence->ring];
-	uint32_t addr = rdev->fence_drv[fence->ring].gpu_addr;
+	uint64_t addr = rdev->fence_drv[fence->ring].gpu_addr;
 
 	radeon_ring_write(ring, PACKET0(UVD_CONTEXT_ID, 0));
 	radeon_ring_write(ring, fence->seq);



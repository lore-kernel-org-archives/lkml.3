Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967731Ab3HIB70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967517Ab3HIB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J.N." <golden.fleeced@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 072/102] drm/radeon: Disable dma rings for bo moves on r6xx
Date: Thu,  8 Aug 2013 18:57:48 -0700
Message-Id: <20130809015027.214661885@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit aeea40cbf9388fc829e66fa049f64d97fd72e118 upstream.

They still seem to cause instability on some r6xx parts.
As a follow up, we can switch to using CP DMA for bo
moves on r6xx as a lighter weight alternative to using
the 3D engine.

A version of this patch should also go to stable kernels.

Tested-by: J.N. <golden.fleeced@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -986,8 +986,8 @@ static struct radeon_asic r600_asic = {
 		.blit_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 		.dma = &r600_copy_dma,
 		.dma_ring_index = R600_RING_TYPE_DMA_INDEX,
-		.copy = &r600_copy_dma,
-		.copy_ring_index = R600_RING_TYPE_DMA_INDEX,
+		.copy = &r600_copy_blit,
+		.copy_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 	},
 	.surface = {
 		.set_reg = r600_set_surface_reg,
@@ -1074,8 +1074,8 @@ static struct radeon_asic rs780_asic = {
 		.blit_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 		.dma = &r600_copy_dma,
 		.dma_ring_index = R600_RING_TYPE_DMA_INDEX,
-		.copy = &r600_copy_dma,
-		.copy_ring_index = R600_RING_TYPE_DMA_INDEX,
+		.copy = &r600_copy_blit,
+		.copy_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 	},
 	.surface = {
 		.set_reg = r600_set_surface_reg,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbbA1BfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:35:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096AbbA1BfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:35:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 10/77] drm/radeon: use rv515_ring_start on r5xx
Date: Tue, 27 Jan 2015 17:26:48 -0800
Message-Id: <20150128012746.280020977@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d8a74e186949e1a2c2f1309212478b0659bf9225 upstream.

This was accidently lost in 76a0df859def.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -335,6 +335,20 @@ static struct radeon_asic_ring r300_gfx_
 	.set_wptr = &r100_gfx_set_wptr,
 };
 
+static struct radeon_asic_ring rv515_gfx_ring = {
+	.ib_execute = &r100_ring_ib_execute,
+	.emit_fence = &r300_fence_ring_emit,
+	.emit_semaphore = &r100_semaphore_ring_emit,
+	.cs_parse = &r300_cs_parse,
+	.ring_start = &rv515_ring_start,
+	.ring_test = &r100_ring_test,
+	.ib_test = &r100_ib_test,
+	.is_lockup = &r100_gpu_is_lockup,
+	.get_rptr = &r100_gfx_get_rptr,
+	.get_wptr = &r100_gfx_get_wptr,
+	.set_wptr = &r100_gfx_set_wptr,
+};
+
 static struct radeon_asic r300_asic = {
 	.init = &r300_init,
 	.fini = &r300_fini,
@@ -756,7 +770,7 @@ static struct radeon_asic rv515_asic = {
 		.set_page = &rv370_pcie_gart_set_page,
 	},
 	.ring = {
-		[RADEON_RING_TYPE_GFX_INDEX] = &r300_gfx_ring
+		[RADEON_RING_TYPE_GFX_INDEX] = &rv515_gfx_ring
 	},
 	.irq = {
 		.set = &rs600_irq_set,
@@ -823,7 +837,7 @@ static struct radeon_asic r520_asic = {
 		.set_page = &rv370_pcie_gart_set_page,
 	},
 	.ring = {
-		[RADEON_RING_TYPE_GFX_INDEX] = &r300_gfx_ring
+		[RADEON_RING_TYPE_GFX_INDEX] = &rv515_gfx_ring
 	},
 	.irq = {
 		.set = &rs600_irq_set,



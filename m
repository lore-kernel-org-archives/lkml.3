Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbaKSV7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:59:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448AbaKSVEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jammy Zhou <Jammy.Zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 038/122] drm/radeon: set correct CE ram size for CIK
Date: Wed, 19 Nov 2014 12:51:28 -0800
Message-Id: <20141119205210.026060719@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jammy Zhou <Jammy.Zhou@amd.com>

commit dc4edad6530a9b7b66c3d905e2bc06021a05dcad upstream.

CE ram size is 32k/0k/0k for GFX/CS0/CS1 with CIK

Ported from amdgpu driver.

Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3936,8 +3936,8 @@ static int cik_cp_gfx_start(struct radeo
 	/* init the CE partitions.  CE only used for gfx on CIK */
 	radeon_ring_write(ring, PACKET3(PACKET3_SET_BASE, 2));
 	radeon_ring_write(ring, PACKET3_BASE_INDEX(CE_PARTITION_BASE));
-	radeon_ring_write(ring, 0xc000);
-	radeon_ring_write(ring, 0xc000);
+	radeon_ring_write(ring, 0x8000);
+	radeon_ring_write(ring, 0x8000);
 
 	/* setup clear context state */
 	radeon_ring_write(ring, PACKET3(PACKET3_PREAMBLE_CNTL, 0));



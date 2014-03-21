Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966265AbaCUBBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:01:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252AbaCUAEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 105/149] drm/radeon/cik: properly set sdma ring status on disable
Date: Thu, 20 Mar 2014 17:04:28 -0700
Message-Id: <20140321000440.600346024@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7b1bbe883b3ed962ca2be4daf321f318f5091340 upstream.

When we disable the rings, set the status properly.  If
not other code pathes may try and use the rings which are
not functional at this point.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik_sdma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -193,6 +193,8 @@ static void cik_sdma_gfx_stop(struct rad
 		WREG32(SDMA0_GFX_RB_CNTL + reg_offset, rb_cntl);
 		WREG32(SDMA0_GFX_IB_CNTL + reg_offset, 0);
 	}
+	rdev->ring[R600_RING_TYPE_DMA_INDEX].ready = false;
+	rdev->ring[CAYMAN_RING_TYPE_DMA1_INDEX].ready = false;
 }
 
 /**



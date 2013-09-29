Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3I2Tca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:32:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3I2T36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        FrankR Huang <FrankR.Huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 36/71] drm/radeon: enable UVD interrupts on CIK
Date: Sun, 29 Sep 2013 12:27:48 -0700
Message-Id: <20130929192645.966372393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 6a3808b8233eb91b57c230cf1161ac116a189ffd upstream.

The same as on evergreen.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-by: FrankR Huang <FrankR.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5763,6 +5763,10 @@ restart_ih:
 				break;
 			}
 			break;
+		case 124: /* UVD */
+			DRM_DEBUG("IH: UVD int: 0x%08x\n", src_data);
+			radeon_fence_process(rdev, R600_RING_TYPE_UVD_INDEX);
+			break;
 		case 146:
 		case 147:
 			addr = RREG32(VM_CONTEXT1_PROTECTION_FAULT_ADDR);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaAMQCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaAMQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/208] drm/radeon: fix typo in cik_copy_dma
Date: Mon, 13 Jan 2014 15:58:07 +0000
Message-Id: <1389628849-1614-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 1b3abef830db98c11d7f916a483abaf2501f3323 upstream.

Otherwise we end up with a rather strange looking result.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Tom Stellard <thomas.stellard@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11:
  - adjusted filename: cik_sdma.c -> cik.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 4a315da..e4182a6 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3643,7 +3643,7 @@ int cik_copy_dma(struct radeon_device *rdev,
 		radeon_ring_write(ring, 0); /* src/dst endian swap */
 		radeon_ring_write(ring, src_offset & 0xffffffff);
 		radeon_ring_write(ring, upper_32_bits(src_offset) & 0xffffffff);
-		radeon_ring_write(ring, dst_offset & 0xfffffffc);
+		radeon_ring_write(ring, dst_offset & 0xffffffff);
 		radeon_ring_write(ring, upper_32_bits(dst_offset) & 0xffffffff);
 		src_offset += cur_size_in_bytes;
 		dst_offset += cur_size_in_bytes;
-- 
1.8.3.2


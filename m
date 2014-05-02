Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaEBPqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEBPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 123/151] drm/radeon: fix endian swap on hawaii clear state buffer setup
Date: Fri,  2 May 2014 08:38:31 -0700
Message-Id: <1399045139-4531-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a8947f576728a66bd3aac629bd8ca021a010c808 upstream.

Need to swap on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 272392d..c46da97 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6318,8 +6318,8 @@ void cik_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer)
 		buffer[count++] = cpu_to_le32(0x00000000);
 		break;
 	case CHIP_HAWAII:
-		buffer[count++] = 0x3a00161a;
-		buffer[count++] = 0x0000002e;
+		buffer[count++] = cpu_to_le32(0x3a00161a);
+		buffer[count++] = cpu_to_le32(0x0000002e);
 		break;
 	default:
 		buffer[count++] = cpu_to_le32(0x00000000);
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaDXI4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:56:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaDXI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 172/182] drm/radeon/si: make sure mc ucode is loaded before checking the size
Date: Thu, 24 Apr 2014 09:51:37 +0100
Message-Id: <1398329507-5911-173-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8c79bae6a30f606b7a4e17c994bc5f72f8fdaf11 upstream.

Avoid a possible segfault.

Noticed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 01c39cf..b1ccf78 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1463,11 +1463,13 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
 	const __be32 *fw_data;
 	u32 running, blackout = 0;
 	u32 *io_mc_regs;
-	int i, regs_size, ucode_size = rdev->mc_fw->size / 4;
+	int i, regs_size, ucode_size;
 
 	if (!rdev->mc_fw)
 		return -EINVAL;
 
+	ucode_size = rdev->mc_fw->size / 4;
+
 	switch (rdev->family) {
 	case CHIP_TAHITI:
 		io_mc_regs = (u32 *)&tahiti_io_mc_regs;
-- 
1.9.1


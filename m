Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaFJTyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbaFJTyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/160] drm/radeon/ci: make sure mc ucode is loaded before checking the size
Date: Tue, 10 Jun 2014 12:44:41 -0700
Message-Id: <1402429600-20477-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit bcddee29b0b87af3aeda953840f97b356b24dc5e upstream.

Avoid a possible segfault.

Noticed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 80ff45e..c8dc6d1 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1704,11 +1704,13 @@ static int ci_mc_load_microcode(struct radeon_device *rdev)
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
 	case CHIP_BONAIRE:
 		io_mc_regs = (u32 *)&bonaire_io_mc_regs;
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaFIJLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:11:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58462 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/146] drm/radeon/si: make sure mc ucode is loaded before checking the size
Date: Mon,  9 Jun 2014 10:49:40 +0200
Message-Id: <5bbd7bffabfb02b0467ccd3c6ade2b32c738eb70.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c79bae6a30f606b7a4e17c994bc5f72f8fdaf11 upstream.

Avoid a possible segfault.

Noticed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/si.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index de0c2bfcc7fc..bbd83f5aa75d 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1475,11 +1475,13 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
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
1.9.3


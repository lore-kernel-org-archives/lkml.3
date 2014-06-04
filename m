Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaFEAgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaFDXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 072/228] drm/radeon/si: make sure mc ucode is loaded before checking the size
Date: Wed,  4 Jun 2014 16:21:41 -0700
Message-Id: <20140604232350.363497933@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8c79bae6a30f606b7a4e17c994bc5f72f8fdaf11 upstream.

Avoid a possible segfault.

Noticed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1472,11 +1472,13 @@ int si_mc_load_microcode(struct radeon_d
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



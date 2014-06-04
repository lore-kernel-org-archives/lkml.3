Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbaFEAg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:36:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaFDXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 071/228] drm/radeon: re-enable mclk dpm on R7 260X asics
Date: Wed,  4 Jun 2014 16:21:40 -0700
Message-Id: <20140604232350.334876252@linuxfoundation.org>
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

commit 7e1858f9aff7d608b3d0abad4bda0130de887b89 upstream.

If the new mc ucode is available.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -21,8 +21,10 @@
  *
  */
 
+#include <linux/firmware.h>
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_ucode.h"
 #include "cikd.h"
 #include "r600_dpm.h"
 #include "ci_dpm.h"
@@ -5106,9 +5108,11 @@ int ci_dpm_init(struct radeon_device *rd
 	pi->mclk_dpm_key_disabled = 0;
 	pi->pcie_dpm_key_disabled = 0;
 
-	/* mclk dpm is unstable on some R7 260X cards */
-	if (rdev->pdev->device == 0x6658)
+	/* mclk dpm is unstable on some R7 260X cards with the old mc ucode */
+	if ((rdev->pdev->device == 0x6658) &&
+	    (rdev->mc_fw->size == (BONAIRE_MC_UCODE_SIZE * 4))) {
 		pi->mclk_dpm_key_disabled = 1;
+	}
 
 	pi->caps_sclk_ds = true;
 



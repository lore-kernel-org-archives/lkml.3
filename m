Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbaGOXgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934003AbaGOXOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.15 56/84] drm/radeon: fix typo in ci_stop_dpm()
Date: Tue, 15 Jul 2014 16:17:53 -0700
Message-Id: <20140715231714.882474501@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ed96377132e564d797c48a5490fd46bed01c4273 upstream.

Need to use the RREG32_SMC() accessor since the register
is an smc indirect index.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -1179,7 +1179,7 @@ static int ci_stop_dpm(struct radeon_dev
 	tmp &= ~GLOBAL_PWRMGT_EN;
 	WREG32_SMC(GENERAL_PWRMGT, tmp);
 
-	tmp = RREG32(SCLK_PWRMGT_CNTL);
+	tmp = RREG32_SMC(SCLK_PWRMGT_CNTL);
 	tmp &= ~DYNAMIC_PM_EN;
 	WREG32_SMC(SCLK_PWRMGT_CNTL, tmp);
 



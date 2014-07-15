Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbaGOXPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbaGOXOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.15 55/84] drm/radeon/dpm: Reenabling SS on Cayman
Date: Tue, 15 Jul 2014 16:17:52 -0700
Message-Id: <20140715231714.851891847@linuxfoundation.org>
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

From: Alexandre Demers <alexandre.f.demers@gmail.com>

commit 41959341ac7e33dd360c7a881d13566f9eca37b2 upstream.

It reverts commit c745fe611ca42295c9d91d8e305d27983e9132ef now that
Cayman is stable since VDDCI fix. Spread spectrum was not the culprit.

This depends on b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman).

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv770_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2329,12 +2329,6 @@ void rv770_get_engine_memory_ss(struct r
 	pi->mclk_ss = radeon_atombios_get_asic_ss_info(rdev, &ss,
 						       ASIC_INTERNAL_MEMORY_SS, 0);
 
-	/* disable ss, causes hangs on some cayman boards */
-	if (rdev->family == CHIP_CAYMAN) {
-		pi->sclk_ss = false;
-		pi->mclk_ss = false;
-	}
-
 	if (pi->sclk_ss || pi->mclk_ss)
 		pi->dynamic_ss = true;
 	else



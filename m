Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209AbaGXKH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:07:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577AbaGXJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/128] drm/radeon/dpm: fix vddci setup typo on cayman
Date: Thu, 24 Jul 2014 10:45:21 +0100
Message-Id: <1406195177-8656-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b0880e87c1fd038b84498944f52e52c3e86ebe59 upstream.

We were using the vddc mask rather than the vddci mask.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=79071

May also fix:
https://bugs.freedesktop.org/show_bug.cgi?id=69723

Noticed by: Dieter Nützel <Dieter@nuetzel-hh.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 4c64254abd0f..596cc12bf356 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -1294,7 +1294,7 @@ static void ni_populate_smc_voltage_tables(struct radeon_device *rdev,
 
 		table->voltageMaskTable.highMask[NISLANDS_SMC_VOLTAGEMASK_VDDCI] = 0;
 		table->voltageMaskTable.lowMask[NISLANDS_SMC_VOLTAGEMASK_VDDCI] =
-			cpu_to_be32(eg_pi->vddc_voltage_table.mask_low);
+			cpu_to_be32(eg_pi->vddci_voltage_table.mask_low);
 	}
 }
 
-- 
1.9.1


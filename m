Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbaHHUtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:49:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbaHHUtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/259] drm/radeon/dpm: fix vddci setup typo on cayman
Date: Fri,  8 Aug 2014 13:37:48 -0700
Message-Id: <1407530482-4483-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 1ee58a3..8c7059d 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -1313,7 +1313,7 @@ static void ni_populate_smc_voltage_tables(struct radeon_device *rdev,
 
 		table->voltageMaskTable.highMask[NISLANDS_SMC_VOLTAGEMASK_VDDCI] = 0;
 		table->voltageMaskTable.lowMask[NISLANDS_SMC_VOLTAGEMASK_VDDCI] =
-			cpu_to_be32(eg_pi->vddc_voltage_table.mask_low);
+			cpu_to_be32(eg_pi->vddci_voltage_table.mask_low);
 	}
 }
 
-- 
1.9.1


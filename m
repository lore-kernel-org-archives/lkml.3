Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaGHAmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:42:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaGGXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 32/94] drm/radeon/dpm: fix typo in vddci setup for eg/btc
Date: Mon,  7 Jul 2014 16:57:22 -0700
Message-Id: <20140707235757.736504648@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e07929810f0a19ddd756558290c7d72827cbfcd9 upstream.

We were using the vddc mask rather than the vddci mask.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=79071

Possibly also fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=68571

Noticed-by:  Jonathan Howard <jonathan@unbiased.name>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cypress_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -1551,7 +1551,7 @@ int cypress_populate_smc_voltage_tables(
 
 		table->voltageMaskTable.highMask[RV770_SMC_VOLTAGEMASK_VDDCI] = 0;
 		table->voltageMaskTable.lowMask[RV770_SMC_VOLTAGEMASK_VDDCI] =
-			cpu_to_be32(eg_pi->vddc_voltage_table.mask_low);
+			cpu_to_be32(eg_pi->vddci_voltage_table.mask_low);
 	}
 
 	return 0;



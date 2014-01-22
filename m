Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaAVNhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:37:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62960 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaAVNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:37:49 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Artem Blagodarenko <artem_blagodarenko@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 6/8] staging/lustre/obdclass: remove extra break in class_process_config
Date: Wed, 22 Jan 2014 21:36:17 +0800
Message-Id: <1390397779-30975-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Blagodarenko <artem_blagodarenko@xyratex.com>

This is only part of the original Lustre commit, splitted to do the
cleanup work.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3155
Lustre-change: http://review.whamcloud.com/6025
Signed-off-by: Artem Blagodarenko <artem_blagodarenko@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/obdclass/obd_config.c    |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 27f56c0..fd08f1d 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1226,24 +1226,20 @@ int class_process_config(struct lustre_cfg *lcfg)
 	case LCFG_POOL_NEW: {
 		err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
 		GOTO(out, err = 0);
-		break;
 	}
 	case LCFG_POOL_ADD: {
 		err = obd_pool_add(obd, lustre_cfg_string(lcfg, 2),
 				   lustre_cfg_string(lcfg, 3));
 		GOTO(out, err = 0);
-		break;
 	}
 	case LCFG_POOL_REM: {
 		err = obd_pool_rem(obd, lustre_cfg_string(lcfg, 2),
 				   lustre_cfg_string(lcfg, 3));
 		GOTO(out, err = 0);
-		break;
 	}
 	case LCFG_POOL_DEL: {
 		err = obd_pool_del(obd, lustre_cfg_string(lcfg, 2));
 		GOTO(out, err = 0);
-		break;
 	}
 	default: {
 		err = obd_process_config(obd, sizeof(*lcfg), lcfg);
-- 
1.7.9.5


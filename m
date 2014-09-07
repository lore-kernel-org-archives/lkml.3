Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaIGQWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:22:34 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:20301
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbaIGQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:31 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047707"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 6/7] staging: lustre: obdclass: expand the GOTO macro + break
Date: Sun,  7 Sep 2014 18:18:34 +0200
Message-Id: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl,rc,f;
constant c;
@@

- GOTO(lbl,\(rc\|rc->f\|c\));
- break;
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
- break;
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/obdclass/obd_config.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index f41695d..8a9752f 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1226,25 +1226,25 @@ int class_process_config(struct lustre_cfg *lcfg)
 	}
 	case LCFG_POOL_NEW: {
 		err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
-		GOTO(out, err = 0);
-		break;
+		err = 0;
+		goto out;
 	}
 	case LCFG_POOL_ADD: {
 		err = obd_pool_add(obd, lustre_cfg_string(lcfg, 2),
 				   lustre_cfg_string(lcfg, 3));
-		GOTO(out, err = 0);
-		break;
+		err = 0;
+		goto out;
 	}
 	case LCFG_POOL_REM: {
 		err = obd_pool_rem(obd, lustre_cfg_string(lcfg, 2),
 				   lustre_cfg_string(lcfg, 3));
-		GOTO(out, err = 0);
-		break;
+		err = 0;
+		goto out;
 	}
 	case LCFG_POOL_DEL: {
 		err = obd_pool_del(obd, lustre_cfg_string(lcfg, 2));
-		GOTO(out, err = 0);
-		break;
+		err = 0;
+		goto out;
 	}
 	default: {
 		err = obd_process_config(obd, sizeof(*lcfg), lcfg);

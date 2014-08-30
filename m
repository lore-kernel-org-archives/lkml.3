Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaH3VNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51554 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbaH3VNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:34 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 11/12] staging/lustre/mdc: remove obsolete llog ioctl handlers
Date: Sat, 30 Aug 2014 17:12:50 -0400
Message-Id: <1409433171-23572-12-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdc_iocontrol() remove the handlers for the obsolete llog ioctls
OBD_IOC_PARSE, OBD_IOC_LLOG_INFO, and OBD_IOC_LLOG_PRINT.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index a2a6334..e6e2515 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1830,7 +1830,6 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 	struct obd_device *obd = exp->exp_obd;
 	struct obd_ioctl_data *data = karg;
 	struct obd_import *imp = obd->u.cli.cl_import;
-	struct llog_ctxt *ctxt;
 	int rc;
 
 	if (!try_module_get(THIS_MODULE)) {
@@ -1886,20 +1885,6 @@ static int mdc_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
 	case IOC_OSC_SET_ACTIVE:
 		rc = ptlrpc_set_import_active(imp, data->ioc_offset);
 		goto out;
-	case OBD_IOC_PARSE: {
-		ctxt = llog_get_context(exp->exp_obd, LLOG_CONFIG_REPL_CTXT);
-		rc = class_config_parse_llog(NULL, ctxt, data->ioc_inlbuf1,
-					     NULL);
-		llog_ctxt_put(ctxt);
-		goto out;
-	}
-	case OBD_IOC_LLOG_INFO:
-	case OBD_IOC_LLOG_PRINT: {
-		ctxt = llog_get_context(obd, LLOG_CONFIG_REPL_CTXT);
-		rc = llog_ioctl(NULL, ctxt, cmd, data);
-		llog_ctxt_put(ctxt);
-		goto out;
-	}
 	case OBD_IOC_POLL_QUOTACHECK:
 		rc = mdc_quota_poll_check(exp, (struct if_quotacheck *)karg);
 		goto out;
-- 
1.9.3


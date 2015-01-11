Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbbAKXCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:02:08 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49199 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAKXCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:02:05 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] usb: as102: as10x_cmd_cfg: Remove unused function
Date: Mon, 12 Jan 2015 00:05:10 +0100
Message-Id: <1421017510-26243-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function as10x_cmd_eLNA_change_mode() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/usb/as102/as10x_cmd.h     |    1 -
 drivers/media/usb/as102/as10x_cmd_cfg.c |   49 -------------------------------
 2 files changed, 50 deletions(-)

diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
index e06b84e..d87fc2f 100644
--- a/drivers/media/usb/as102/as10x_cmd.h
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -518,6 +518,5 @@ int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap,
 			  uint16_t tag,
 			  uint32_t *pvalue);
 
-int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode);
 int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
 #endif
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
index c87f2ca..74def1f 100644
--- a/drivers/media/usb/as102/as10x_cmd_cfg.c
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -130,55 +130,6 @@ out:
 }
 
 /**
- * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
- * @adap:      pointer to AS10x bus adapter
- * @mode:      mode selected:
- *	        - ON    : 0x0 => eLNA always ON
- *	        - OFF   : 0x1 => eLNA always OFF
- *	        - AUTO  : 0x2 => eLNA follow hysteresis parameters
- *				 to be ON or OFF
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.cfg_change_mode.req));
-
-	/* fill command */
-	pcmd->body.cfg_change_mode.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
-	pcmd->body.cfg_change_mode.req.mode = mode;
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error  = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.cfg_change_mode.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.cfg_change_mode.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
-
-out:
-	return error;
-}
-
-/**
  * as10x_context_rsp_parse - Parse context command response
  * @prsp:       pointer to AS10x command response buffer
  * @proc_id:    id of the command
-- 
1.7.10.4


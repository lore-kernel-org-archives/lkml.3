Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaFOGYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:24:09 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:5188 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbaFOGYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:24:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEGAGI7nVNXQzGY/2dsb2JhbABagw2rDgYBAwEGmSSBAxd1hDEvI4EaN4hGAc8LF4VjiRMdhC0EmkOLMIgog0I7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1 RESEND] drivers/misc/carma/carma-fpga.c: use PTR_ERR_OR_ZERO
Date: Sun, 15 Jun 2014 08:22:42 +0200
Message-Id: <1402813362-2617-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 drivers/misc/carma/carma-fpga.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 14d90ea..55e913b 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -954,10 +954,7 @@ static int data_debugfs_init(struct fpga_device *priv)
 {
 	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
 					      &data_debug_fops);
-	if (IS_ERR(priv->dbg_entry))
-		return PTR_ERR(priv->dbg_entry);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(priv->dbg_entry);
 }
 
 static void data_debugfs_exit(struct fpga_device *priv)
-- 
1.8.4.5


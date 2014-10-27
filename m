Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaJ0UYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:24:22 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40883 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0UYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:24:20 -0400
From: Marek Belisko <marek@goldelico.com>
To: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com
Cc: hns@goldelico.com, marek@goldelico.com, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] omap: dss: connector-analog-tv: Add missing module device table
Date: Mon, 27 Oct 2014 21:24:03 +0100
Message-Id: <1414441443-10224-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without that fix connector-analog-tv driver isn't probed when compiled
as module.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
index 5ee3b55..d29cf72 100644
--- a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
+++ b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
@@ -301,6 +301,8 @@ static const struct of_device_id tvc_of_match[] = {
 	{},
 };
 
+MODULE_DEVICE_TABLE(of, tvc_of_match);
+
 static struct platform_driver tvc_connector_driver = {
 	.probe	= tvc_probe,
 	.remove	= __exit_p(tvc_remove),
-- 
1.9.1


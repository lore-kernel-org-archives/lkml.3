Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaLUVPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:39 -0500
Received: from sauhun.de ([89.238.76.85]:52869 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaLUVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:21 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 04/28] char: ipmi: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:25 +0100
Message-Id: <1419196495-9626-5-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/char/ipmi/ipmi_powernv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_powernv.c b/drivers/char/ipmi/ipmi_powernv.c
index 79524ed2a3cb..d7acb04d3982 100644
--- a/drivers/char/ipmi/ipmi_powernv.c
+++ b/drivers/char/ipmi/ipmi_powernv.c
@@ -294,7 +294,6 @@ static const struct of_device_id ipmi_powernv_match[] = {
 static struct platform_driver powernv_ipmi_driver = {
 	.driver = {
 		.name		= "ipmi-powernv",
-		.owner		= THIS_MODULE,
 		.of_match_table	= ipmi_powernv_match,
 	},
 	.probe	= ipmi_powernv_probe,
-- 
2.1.3


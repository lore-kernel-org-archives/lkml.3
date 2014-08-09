Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaHIXmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:42:53 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56736 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaHIXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:42:52 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] misc: c2port: core.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:44:21 +0200
Message-Id: <1407627861-24513-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/misc/c2port/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index 464419b..62b0baa 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -933,6 +933,7 @@ struct c2port_device *c2port_device_register(char *name,
 	dev_set_drvdata(c2dev->dev, c2dev);
 
 	strncpy(c2dev->name, name, C2PORT_NAME_LEN);
+	c2dev->name[C2PORT_NAME_LEN - 1] = '\0';
 	c2dev->ops = ops;
 	mutex_init(&c2dev->mutex);
 
-- 
1.7.10.4


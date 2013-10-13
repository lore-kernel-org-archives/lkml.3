Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3JMD74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 23:59:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55996 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753797Ab3JMD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 23:59:55 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ipmi: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 05:59:50 +0200
Message-Id: <1381636790-5943-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 15e4a60..68c5ef5 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1358,7 +1358,7 @@ static int std_irq_setup(struct smi_info *info)
 	if (info->si_type == SI_BT) {
 		rv = request_irq(info->irq,
 				 si_bt_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED,
 				 DEVICE_NAME,
 				 info);
 		if (!rv)
@@ -1368,7 +1368,7 @@ static int std_irq_setup(struct smi_info *info)
 	} else
 		rv = request_irq(info->irq,
 				 si_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED,
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
-- 
1.8.1.2


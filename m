Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaAXUBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:01:24 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:65134 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaAXUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:01:22 -0500
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/4] ipmi: remove deprecated IRQF_DISABLED
Date: Fri, 24 Jan 2014 14:00:50 -0600
Message-Id: <1390593653-5408-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1390593653-5408-1-git-send-email-minyard@acm.org>
References: <1390593653-5408-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
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
1.8.3.1


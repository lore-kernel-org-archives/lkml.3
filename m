Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab3IELg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:36:58 -0400
Received: from vms173023pub.verizon.net ([206.46.173.23]:32874 "EHLO
	vms173023pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935715Ab3IELgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:36:55 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/4] ipmi: Initialize locals to avoid warning
Date: Thu, 05 Sep 2013 06:36:34 -0500
Message-id: <1378380996-4844-3-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378380996-4844-1-git-send-email-minyard@acm.org>
References: <1378380996-4844-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

A couple of variables were getting warnings about being uninitialized.
It was a false warning, but initialize them, anyway.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 4445fa1..ec4e10f 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1848,7 +1848,7 @@ int ipmi_request_settime(ipmi_user_t      user,
 			 int              retries,
 			 unsigned int     retry_time_ms)
 {
-	unsigned char saddr, lun;
+	unsigned char saddr = 0, lun = 0;
 	int           rv;
 
 	if (!user)
-- 
1.7.9.5


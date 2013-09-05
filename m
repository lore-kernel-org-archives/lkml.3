Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935803Ab3IELg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:36:56 -0400
Received: from vms173023pub.verizon.net ([206.46.173.23]:32874 "EHLO
	vms173023pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935784Ab3IELgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:36:54 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/4] ipmi: info leak in compat_ipmi_ioctl()
Date: Thu, 05 Sep 2013 06:36:33 -0500
Message-id: <1378380996-4844-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378380996-4844-1-git-send-email-minyard@acm.org>
References: <1378380996-4844-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

On x86_64 there is a 4 byte hole between ->recv_type and ->addr.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_devintf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index d5a5f02..ec318bf 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -810,6 +810,7 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		struct ipmi_recv   __user *precv64;
 		struct ipmi_recv   recv64;
 
+		memset(&recv64, 0, sizeof(recv64));
 		if (get_compat_ipmi_recv(&recv64, compat_ptr(arg)))
 			return -EFAULT;
 
-- 
1.7.9.5


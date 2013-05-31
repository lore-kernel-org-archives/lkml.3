Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3EaMrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:47:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21322 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3EaMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:47:16 -0400
Date: Fri, 31 May 2013 15:46:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] ipmi: info leak in compat_ipmi_ioctl()
Message-ID: <20130531124658.GU23987@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 there is a 4 byte hole between ->recv_type and ->addr.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fixed the changelog a little.  Also added LKML because the
openipmi is a moderated list (and the moderator thought my email was
spam).

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 9eb360f..8e306ac 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -810,6 +810,7 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		struct ipmi_recv   __user *precv64;
 		struct ipmi_recv   recv64;
 
+		memset(&recv64, 0, sizeof(recv64));
 		if (get_compat_ipmi_recv(&recv64, compat_ptr(arg)))
 			return -EFAULT;
 

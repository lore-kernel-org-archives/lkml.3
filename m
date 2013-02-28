Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3B1Tq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:46:59 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49790 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3B1Tq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:46:58 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 28 Feb 2013 13:46:58 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: dgrp: Drop unnecessary typecast
Date: Thu, 28 Feb 2013 11:46:57 -0800
Message-Id: <1362080817-2098-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unnecessary typecast in dgrp_net_ops.c causes the following build error
if compiled with W=1.

In function ‘copy_from_user’, inlined from ‘dgrp_net_ioctl’ at
    drivers/staging/dgrp/dgrp_net_ops.c:3408:21:
    arch/x86/include/asm/uaccess_32.h:211:26: error: call to
    ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
    buffer size is not provably correct

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/dgrp/dgrp_net_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index e6018823..f364e8e 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -3405,7 +3405,7 @@ static long dgrp_net_ioctl(struct file *file, unsigned int cmd,
 		if (size != sizeof(struct link_struct))
 			return -EINVAL;
 
-		if (copy_from_user((void *)(&link), (void __user *) arg, size))
+		if (copy_from_user(&link, (void __user *)arg, size))
 			return -EFAULT;
 
 		if (link.lk_fast_rate < 9600)
-- 
1.7.9.7


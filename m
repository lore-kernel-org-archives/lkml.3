Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3IQKsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:48:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3IQKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:48:07 -0400
Date: Tue, 17 Sep 2013 13:47:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pinctrl: remove an unnecessary cast
Message-ID: <20130917104754.GA29918@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof() is already size_t so there is no need to cast here.  Generally,
casting inside the min() macro instead of using min_t() is considered
bad style.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index a138965..abe66d4 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -508,7 +508,7 @@ static int pinconf_dbg_config_write(struct file *file,
 	int i;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (size_t)(sizeof(buf)-1));
+	buf_size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	buf[buf_size] = 0;

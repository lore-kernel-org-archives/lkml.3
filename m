Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaGQMTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:19:08 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48071 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaGQMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:19:04 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dcb314@hotmail.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 2/3] drivers/char/dsp56k.c: drop check for negativity of unsigned parameter
Date: Thu, 17 Jul 2014 15:18:53 +0300
Message-Id: <1405599533-11374-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/char/dsp56k.c:386]: (style) Checking if unsigned
variable 'arg' is less than zero.

Source code is

            if (arg > 31 || arg < 0)
                return -EINVAL;

But

static long dsp56k_ioctl(struct file *file, unsigned int cmd,
             unsigned long arg)

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80411
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/char/dsp56k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index 01a5ca7..8bf70e8 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -383,7 +383,7 @@ static long dsp56k_ioctl(struct file *file, unsigned int cmd,
 			return put_user(status, &hf->status);
 		}
 		case DSP56K_HOST_CMD:
-			if (arg > 31 || arg < 0)
+			if (arg > 31)
 				return -EINVAL;
 			mutex_lock(&dsp56k_mutex);
 			dsp56k_host_interface.cvr = (u_char)((arg & DSP56K_CVR_HV_MASK) |
-- 
1.8.5.5


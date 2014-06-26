Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbaFZR3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:29:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53747 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbaFZR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:29:06 -0400
Date: Thu, 26 Jun 2014 22:58:52 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] HID: roccat: Drop cast
Message-ID: <20140626172852.GA2878@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the cast on data of type void* as it is not needed.
The following Coccinelle semantic patch was used for making the change:

@r@
expression x;
void* e;
type T;
identifier f;
@@

(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (T *)
  e
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/hid/hid-roccat-lua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-roccat-lua.c b/drivers/hid/hid-roccat-lua.c
index 6adc0fa..65e2e76 100644
--- a/drivers/hid/hid-roccat-lua.c
+++ b/drivers/hid/hid-roccat-lua.c
@@ -61,7 +61,7 @@ static ssize_t lua_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&lua->lua_lock);
-	retval = roccat_common2_send(usb_dev, command, (void *)buf, real_size);
+	retval = roccat_common2_send(usb_dev, command, buf, real_size);
 	mutex_unlock(&lua->lua_lock);
 
 	return retval ? retval : real_size;
-- 
1.9.1


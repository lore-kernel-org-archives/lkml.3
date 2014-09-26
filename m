Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaIZPgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:36:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62055 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaIZPgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:36:07 -0400
Message-ID: <542587E3.4040605@gmail.com>
Date: Fri, 26 Sep 2014 23:36:03 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] xen/xenbus: Remove BUG_ON() when error string trucated
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xenbus_va_dev_error() is for printing error, so when error string is
too long to be truncated, need not BUG_ON(), still return truncation
string is OK.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/xenbus/xenbus_client.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index aa9b2fc..ca74410 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -259,7 +259,6 @@ static char *error_path(struct xenbus_device *dev)
 static void xenbus_va_dev_error(struct xenbus_device *dev, int err,
 				const char *fmt, va_list ap)
 {
-	int ret;
 	unsigned int len;
 	char *printf_buffer = NULL;
 	char *path_buffer = NULL;
@@ -270,9 +269,7 @@ static void xenbus_va_dev_error(struct xenbus_device *dev, int err,
 		goto fail;
 
 	len = sprintf(printf_buffer, "%i ", -err);
-	ret = vsnprintf(printf_buffer+len, PRINTF_BUFFER_SIZE-len, fmt, ap);
-
-	BUG_ON(len + ret > PRINTF_BUFFER_SIZE-1);
+	vsnprintf(printf_buffer+len, PRINTF_BUFFER_SIZE-len, fmt, ap);
 
 	dev_err(&dev->dev, "%s\n", printf_buffer);
 
-- 
1.9.3

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaIROAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:00:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51573 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaIROAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:00:08 -0400
Message-ID: <541AE56F.8040005@gmail.com>
Date: Thu, 18 Sep 2014 22:00:15 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3 v2] xen/xenbus: Remove BUG_ON() when error string trucated
References: <541AE4E9.2040904@gmail.com>
In-Reply-To: <541AE4E9.2040904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xenbus_va_dev_error() is for printing error, so when error string is
too long to be trancated, need not BUG_ON(), still return truncation
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

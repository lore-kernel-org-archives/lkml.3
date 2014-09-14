Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaINKvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:51:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60939 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaINKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:51:39 -0400
Message-ID: <54157340.4060508@gmail.com>
Date: Sun, 14 Sep 2014 18:51:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] drivers/xen/xenbus/xenbus_client.c: Remove BUG_ON() when
 error string truncated
References: <54157282.40402@gmail.com>
In-Reply-To: <54157282.40402@gmail.com>
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
index e2cf681..620ffd2 100644
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

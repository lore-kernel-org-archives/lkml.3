Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3EICQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:16:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46235 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EICQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:16:58 -0400
MIME-Version: 1.0
Date: Thu, 9 May 2013 10:16:56 +0800
Message-ID: <CAPgLHd89se7-uM4XG1A3kaaH+dQE4W7WfFru8c9fiP9yujBojQ@mail.gmail.com>
Subject: [PATCH] uio: fix error return code in uio_dev_add_attributes()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kobject_create_and_add() and kzalloc() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/uio/uio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index b645c47..c6dfc31 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -276,6 +276,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
+		ret = -ENOMEM;
 		if (!map_found) {
 			map_found = 1;
 			idev->map_dir = kobject_create_and_add("maps",
@@ -301,6 +302,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		port = &idev->info->port[pi];
 		if (port->size == 0)
 			break;
+		ret = -ENOMEM;
 		if (!portio_found) {
 			portio_found = 1;
 			idev->portio_dir = kobject_create_and_add("portio",


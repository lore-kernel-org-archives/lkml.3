Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3LSPIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:43 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65391 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3LSPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:40 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, linux-usb@vger.kernel.org
Subject: [PATCH 37/38] uwb: umc-dev: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:51 +0100
Message-Id: <1387465612-3673-38-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/uwb/umc-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uwb/umc-dev.c b/drivers/uwb/umc-dev.c
index 4613c13..7b0b268 100644
--- a/drivers/uwb/umc-dev.c
+++ b/drivers/uwb/umc-dev.c
@@ -66,6 +66,7 @@ int umc_device_register(struct umc_dev *umc)
 	return 0;
 
 error_device_register:
+	put_device(&umc->dev);
 	release_resource(&umc->resource);
 error_request_resource:
 	return err;
-- 
1.8.3.1


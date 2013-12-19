Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3LSPIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:35 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47099 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3LSPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:31 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>
Subject: [PATCH 36/38] dio: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:50 +0100
Message-Id: <1387465612-3673-37-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/dio/dio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 55dd88d..5d4d755 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -186,6 +186,7 @@ static int __init dio_init(void)
 	error = device_register(&dio_bus.dev);
 	if (error) {
 		pr_err("DIO: Error registering dio_bus\n");
+		put_device(&dio_bus.dev);
 		return error;
 	}
 
-- 
1.8.3.1


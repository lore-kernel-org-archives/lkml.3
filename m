Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaCEChW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:37:22 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60660 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbaCEChV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:37:21 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dulshani.gunawardhana89@gmail.com, sachin.kamat@linaro.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cxt1e1: use kzalloc instead of kmalloc/memset 0
Date: Wed, 05 Mar 2014 11:37:15 +0900
Message-ID: <1673333.LFj7fBDsDS@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/sbecom_inline_linux.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index ba3ff3e..6dd1b55 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -46,11 +46,9 @@ void        pci_write_32 (u_int32_t *p, u_int32_t v);
 static inline void *
 OS_kmalloc (size_t size)
 {
-    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
+	char *ptr = kzalloc(size, GFP_KERNEL | GFP_DMA);
 
-    if (ptr)
-        memset (ptr, 0, size);
-    return ptr;
+	return ptr;
 }
 
 static inline void
-- 
1.7.4.4



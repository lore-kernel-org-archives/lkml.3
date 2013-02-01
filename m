Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab3BAUw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:52:59 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:51109 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3BAUwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:45 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 16/16] zcache/zbud: Fix __init mismatch
Date: Fri,  1 Feb 2013 15:52:19 -0500
Message-Id: <1359751939-23584-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
References: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get:
WARNING: drivers/staging/zcache/zcache.o(.text+0x13a1): Section mismatch
in reference from the function zcache_init() to the function
.init.text:zbud_init()
The function zcache_init() references
the function __init zbud_init().
This is often because zcache_init lacks a __init
annotation or the annotation of zbud_init is wrong.

And this fixes it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zbud.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index e139cd6..9aa5bd8 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -1077,7 +1077,7 @@ out:
 	return ret;
 }
 
-void __init zbud_init(void)
+void zbud_init(void)
 {
 	int i;
 
-- 
1.7.11.7


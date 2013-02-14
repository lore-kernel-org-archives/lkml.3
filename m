Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3BNDF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:05:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 16/16] zcache/zbud: Fix __init mismatch
Date: Wed, 13 Feb 2013 22:05:06 -0500
Message-Id: <1360811106-2679-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
1.8.0.2


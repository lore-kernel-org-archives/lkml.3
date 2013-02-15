Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3BOR6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:58:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3BOR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:58:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] zcache/zbud: Fix __init mismatch
Date: Fri, 15 Feb 2013 12:53:44 -0500
Message-Id: <1360950824-11032-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
References: <20130214172926.GA17343@kroah.com>
 <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zbud.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index 4654978..ee927e8 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -1047,7 +1047,7 @@ out:
 	return ret;
 }
 
-void __init zbud_init(void)
+void zbud_init(void)
 {
 	int i;
 
-- 
1.8.0.2


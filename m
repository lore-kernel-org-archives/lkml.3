Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3CGANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:13:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3CGANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:13:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, greg@kroah.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] zcache/debug: compiler failure on PPC64.
Date: Wed,  6 Mar 2013 19:13:36 -0500
Message-Id: <1362615216-12293-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC64 we get this:
In file included from drivers/staging/zcache/debug.c:2:
drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
drivers/staging/zcache/debug.h:16: error: implicit declaration of function 'BUG_ON'

This simple patch adds the appropiate header file to finish
the compile.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index eef67db..0d9c6b4 100644
--- a/drivers/staging/zcache/debug.h
+++ b/drivers/staging/zcache/debug.h
@@ -1,5 +1,6 @@
 #ifdef CONFIG_ZCACHE_DEBUG
 
+#include <linux/bug.h>
 /* we try to keep these statistics SMP-consistent */
 static ssize_t zcache_obj_count;
 static atomic_t zcache_obj_atomic = ATOMIC_INIT(0);
-- 
1.8.0.2


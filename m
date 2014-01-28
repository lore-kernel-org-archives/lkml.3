Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaA1UQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:16:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:59836 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaA1UQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:16:54 -0500
From: xypron.glpk@gmx.de
To: gregkh@linuxfoundation.org
Cc: xypron.glpk@gmx.de, ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Date: Tue, 28 Jan 2014 21:16:46 +0100
Message-Id: <1390940206-7256-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140127225247.GG7444@mwanda>
References: <20140127225247.GG7444@mwanda>
X-Provags-ID: V03:K0:4RqOALYAjs119/dOZwC5yoSChiNH8gIEBYLqIfd8wrNpnfqOlOX
 AJTj5OoKwDhlmNZ5LSjMnEDlOMpVsUqVDBlia9Bw3U2Xev1RMQqMJMVp+fDFV99kduOxO6g
 sOSABJdvNXwhZ0qEjRG+lIglE+8g7wAYBKY/es7kquY1x0K1GAwm7HQFFSTphFpcBrtcA7A
 5q7otjaHCQ49fdtQXwX6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

revised patch

p is freed if NULL.
p is leaked if second calloc fails.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/usbip/userspace/libsrc/names.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
index 3c8d28b..81ff852 100644
--- a/drivers/staging/usbip/userspace/libsrc/names.c
+++ b/drivers/staging/usbip/userspace/libsrc/names.c
@@ -169,14 +169,14 @@ static void *my_malloc(size_t size)
 	struct pool *p;
 
 	p = calloc(1, sizeof(struct pool));
-	if (!p) {
-		free(p);
+	if (!p)
 		return NULL;
-	}
 
 	p->mem = calloc(1, size);
-	if (!p->mem)
+	if (!p->mem) {
+		free(p);
 		return NULL;
+	}
 
 	p->next = pool_head;
 	pool_head = p;
-- 
1.7.10.4


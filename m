Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaDDWc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:32:27 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45747 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaDDWcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:32:24 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [WIP] [PATCH v2 1/3] staging: vt6655: removed incorrect casting in wpactl.c
Date: Sat,  5 Apr 2014 00:32:08 +0200
Message-Id: <41f9419737ba44ad4d5e4418210f708dfa4a7f7a.1396627781.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <cover.1396627781.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <20140403094350.GH6991@mwanda> <cover.1396627781.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following type of sparse warnings:

drivers/staging/vt6655/wpactl.c:596:47: warning: cast from restricted gfp_t
drivers/staging/vt6655/wpactl.c:638:68: warning: cast from restricted gfp_t
drivers/staging/vt6655/wpactl.c:860:42: warning: cast from restricted gfp_t

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 drivers/staging/vt6655/wpactl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index d17224f..4745429 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -593,7 +593,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
 	unsigned char *ptempBSS;
 
-	ptempBSS = kmalloc(sizeof(KnownBSS), (int)GFP_ATOMIC);
+	ptempBSS = kmalloc(sizeof(KnownBSS), GFP_ATOMIC);
 
 	if (ptempBSS == NULL) {
 		printk(KERN_ERR "bubble sort kmalloc memory fail@@@\n");
@@ -635,7 +635,7 @@ static int wpa_get_scan(PSDevice pDevice,
 		count++;
 	}
 
-	pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
+	pBuf = kcalloc(count, sizeof(struct viawget_scan_result), GFP_ATOMIC);
 
 	if (pBuf == NULL) {
 		ret = -ENOMEM;
@@ -857,7 +857,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	    p->length > VIAWGET_WPA_MAX_BUF_SIZE || !p->pointer)
 		return -EINVAL;
 
-	param = kmalloc((int)p->length, (int)GFP_KERNEL);
+	param = kmalloc((int)p->length, GFP_KERNEL);
 	if (param == NULL)
 		return -ENOMEM;
 
-- 
1.9.0


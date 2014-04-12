Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaDLAbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 20:31:04 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44441 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbaDLAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 20:30:36 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v3 1/3] staging: vt6655: removed incorrect casting in wpactl.c
Date: Sat, 12 Apr 2014 02:30:24 +0200
Message-Id: <0147390e77605c761a903394b158997995385199.1397260702.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <cover.1397260702.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <20140410201606.GA12335@kroah.com> <cover.1397260702.git.silvio.fricke@gmail.com>
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
1.9.2


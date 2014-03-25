Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaCYUai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:30:38 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39326 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaCYUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:30:36 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
From: silvio@port1024.net
To: linux-kernel@vger.kernel.org
Cc: silvio@port1024.net, Silvio F <silvio.fricke@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/3] staging: vt6655: removed incorrect casting in wpactl.c
Date: Tue, 25 Mar 2014 21:30:18 +0100
Message-Id: <9ae62ba7dd9abff5839457e0870f75a53b1bc709.1395778852.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <cover.1395778852.git.silvio.fricke@gmail.com>
References: <cover.1395778852.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1395778852.git.silvio.fricke@gmail.com>
References: <1395362529-17182-1-git-send-email-cse.cem@gmail.com> <cover.1395778852.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silvio F <silvio.fricke@gmail.com>

This patch fixes the following type of sparse warnings:

drivers/staging/vt6655/wpactl.c:596:47: warning: cast from restricted gfp_t
drivers/staging/vt6655/wpactl.c:638:68: warning: cast from restricted gfp_t
drivers/staging/vt6655/wpactl.c:860:42: warning: cast from restricted gfp_t

Signed-off-by: Silvio F <silvio.fricke@gmail.com>
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


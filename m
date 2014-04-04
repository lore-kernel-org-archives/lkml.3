Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaDDWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:32:29 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38890 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaDDWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:32:25 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [WIP] [PATCH v2 2/3] staging: vt6655: removed incorrect casting in ioctl.c
Date: Sat,  5 Apr 2014 00:32:09 +0200
Message-Id: <48d006d4888590f64a1c40fe91bfc4a92c16a896.1396627781.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <cover.1396627781.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <20140403094350.GH6991@mwanda> <cover.1396627781.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following type of sparse warnings:

drivers/staging/vt6655/ioctl.c:308:104: warning: cast from restricted gfp_t
drivers/staging/vt6655/ioctl.c:579:109: warning: cast from restricted gfp_t

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 drivers/staging/vt6655/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index b5cd2e4..1de5d2c9 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -305,7 +305,8 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EINVAL;
 			break;
 		}
-		pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), (int)GFP_ATOMIC);
+		pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)),
+					     GFP_ATOMIC);
 		if (pList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -576,7 +577,8 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EINVAL;
 			break;
 		}
-		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
+		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)),
+						GFP_ATOMIC);
 		if (pNodeList == NULL) {
 			result = -ENOMEM;
 			break;
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaDLAbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 20:31:33 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63308 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaDLAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 20:30:38 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v3 2/3] staging: vt6655: removed incorrect casting in ioctl.c
Date: Sat, 12 Apr 2014 02:30:25 +0200
Message-Id: <14070162d25289e27a3c25e6d37718f65afc8718.1397260702.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <cover.1397260702.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <20140410201606.GA12335@kroah.com> <cover.1397260702.git.silvio.fricke@gmail.com>
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
1.9.2


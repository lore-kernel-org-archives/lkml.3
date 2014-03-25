Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaCYUaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:30:52 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49562 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbaCYUas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:30:48 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
From: silvio@port1024.net
To: linux-kernel@vger.kernel.org
Cc: silvio@port1024.net, Silvio F <silvio.fricke@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/3] staging: vt6655: removed incorrect casting in ioctl.c
Date: Tue, 25 Mar 2014 21:30:19 +0100
Message-Id: <b717a8406241d9bb3381d5faa1ce6914e16e51a4.1395778852.git.silvio.fricke@gmail.com>
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

drivers/staging/vt6655/ioctl.c:308:104: warning: cast from restricted gfp_t
drivers/staging/vt6655/ioctl.c:579:109: warning: cast from restricted gfp_t

Signed-off-by: Silvio F <silvio.fricke@gmail.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbaGXXHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:07:13 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34514 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 06/14] staging: vt6655: fix static position in inline function
Date: Fri, 25 Jul 2014 01:06:20 +0200
Message-Id: <1406243188-13413-7-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be "static inline", not "inline static". Reported by
checkpatch.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/device.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 7c7fec4..a707984 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -778,7 +778,7 @@ inline  static	void   EnQueue(PSDevice pDevice, PSRxMgmtPacket  pRxMgmtPacket)
 	}
 }
 
-inline  static  PSRxMgmtPacket DeQueue(PSDevice pDevice)
+static inline PSRxMgmtPacket DeQueue(PSDevice pDevice)
 {
 	PSRxMgmtPacket  pRxMgmtPacket;
 
@@ -800,7 +800,7 @@ void	InitRxManagementQueue(PSDevice   pDevice);
 
 //PLICE_DEBUG<-
 
-inline static bool device_get_ip(PSDevice pInfo) {
+static inline bool device_get_ip(PSDevice pInfo) {
 	struct in_device *in_dev = (struct in_device *)pInfo->dev->ip_ptr;
 	struct in_ifaddr *ifa;
 
-- 
1.8.5.5


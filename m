Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3BETem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:34:42 -0500
Received: from mout.gmx.net ([212.227.15.18]:65393 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab3BETek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:34:40 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+BfMUJhXeBBKVPoO4+G49cPlg/6GmyRESwK3oGM3
	X/dYjG3x1wa5ih
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/xgifb: Remove unused variable
Date: Tue,  5 Feb 2013 20:38:35 +0100
Message-Id: <1360093115-4132-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20130205191802.GA24182@kroah.com>
References: <20130205191802.GA24182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patch
'staging/xgifb: Don't write the same values x times'
the local variable i is unused, which leads to the following warning:

driverrs/staging/xgifb/vb_init.c: In function
‘XGINew_SetDRAMDefaultRegister340’:
drivers/staging/xgifb/vb_init.c:433:43: warning: unused variable ‘i’
[-Wunused-variable]

This patch fixes this

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Sorry that I missed that one in the patch series.

 drivers/staging/xgifb/vb_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 1c6e0f3..7b8f41d 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -430,7 +430,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
 {
-	unsigned char temp, temp1, temp2, temp3, i, j, k;
+	unsigned char temp, temp1, temp2, temp3, j, k;
 
 	unsigned long P3d4 = Port, P3c4 = Port - 0x10;
 
-- 
1.7.8.6


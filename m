Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3BEV3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:29:03 -0500
Received: from mout.gmx.net ([212.227.15.19]:56518 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3BEV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:28:59 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19g/T9NDH1grftOfG/KA27xnqO8zBAs1NVyDrb4fn
	61b7I9Ln1x9CEZ
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging/xgifb: Remove unused entries in XGI340New_MCLKData and XGI27New_MCLKData
Date: Tue,  5 Feb 2013 22:32:31 +0100
Message-Id: <1360099954-8612-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
References: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the lookup tables XGI340New_MCLKData and XGI27New_MCLKData only the
first three 'lines' are used, thus the remaining fields can be removed.

Rationale:
- vb_init.c uses pVBInfo->ram_type as the index for pVBInfo->MCLKData

- pVBInfo->ram_type is assigned the return value of
XGINew_GetXG20DRAMType which can only be 0, 1 or 2

- pVBInfo->MCLKData is assigned to either XGI340New_MCLKData or
XGI27New_MCLKData in vb_setmode.c

-> only the first three values are used, the rest can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_table.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index b7abe25..04fd5cf 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -4,22 +4,12 @@ static const struct SiS_MCLKData XGI340New_MCLKData[] = {
 	{0x16, 0x01, 0x01, 166},
 	{0x19, 0x02, 0x01, 124},
 	{0x7C, 0x08, 0x01, 200},
-	{0x79, 0x06, 0x01, 250},
-	{0x29, 0x01, 0x81, 301},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166}
 };
 
 static const struct SiS_MCLKData XGI27New_MCLKData[] = {
 	{0x5c, 0x23, 0x01, 166},
 	{0x19, 0x02, 0x01, 124},
 	{0x7C, 0x08, 0x80, 200},
-	{0x79, 0x06, 0x80, 250},
-	{0x29, 0x01, 0x81, 300},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166}
 };
 
 const struct XGI_ECLKDataStruct XGI340_ECLKData[] = {
-- 
1.7.8.6


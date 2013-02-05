Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3BEV3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:29:46 -0500
Received: from mout.gmx.net ([212.227.17.21]:51101 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab3BEV3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:29:03 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Zmm8iK7PZLuy1LyyQ64XWRIY33RdQRZ4Puor1qQ
	SJQvIlfD8ngXFP
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging/xgifb: Remove unused values in XGI340_ECLKData
Date: Tue,  5 Feb 2013 22:32:32 +0100
Message-Id: <1360099954-8612-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
References: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the lookup table XGI340_ECLKData only the first three 'lines' are
used, thus the remaining entries can be removed.

Rationale:
- vb_init.c uses pVBInfo->ram_type as the index for XGI340_ECLKData.

- pVBInfo->ram_type is assigned the return value of
XGINew_GetXG20DRAMType which can only be 0, 1 or 2

-> only the first three values are used.
-> remove the remeining entries.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_table.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 04fd5cf..b4c05c8 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -16,11 +16,6 @@ const struct XGI_ECLKDataStruct XGI340_ECLKData[] = {
 	{0x5c, 0x23, 0x01, 166},
 	{0x55, 0x84, 0x01, 123},
 	{0x7C, 0x08, 0x01, 200},
-	{0x79, 0x06, 0x01, 250},
-	{0x29, 0x01, 0x81, 301},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166},
-	{0x5c, 0x23, 0x01, 166}
 };
 
 static const unsigned char XG27_SR13[4][3] = {
-- 
1.7.8.6


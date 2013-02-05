Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3BEV27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:28:59 -0500
Received: from mout.gmx.net ([212.227.15.19]:52291 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab3BEV24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:28:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/nXwB47UbnK+VmjJP0F3RI2inqRbCisYMHvlOjfC
	qAqiFq97PqvQOd
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging/xgifb: Remove unused values in XG27_SR13 and XGI340_SR13
Date: Tue,  5 Feb 2013 22:32:30 +0100
Message-Id: <1360099954-8612-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
References: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In the lookup tables XG27_SR13 and XGI340_SR13 only the first three
 values are used of each 'line', thus the remaining fields can be
 removed.

Rationale:
- vb_init.c uses pVBInfo->ram_type for the 'column' index for
pVBInfo->SR15.

- pVBInfo->ram_type is assigned the return value of
XGINew_GetXG20DRAMType which can only be 0, 1 or 2

- pVBInfo->SR15 is assigned to either XG27_SR13 or XGI340_SR13 in
vb_setmode.c

-> only the first three values are used.
This becomes also evident as values 3-7 are all 0.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_struct.h |    2 +-
 drivers/staging/xgifb/vb_table.h  |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index 02f3bb5..ae0c18b 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -157,7 +157,7 @@ struct vb_device_info {
 
 	void __iomem *FBAddr;
 
-	unsigned char const (*SR15)[8];
+	unsigned char const (*SR15)[3];
 	unsigned char const (*CR40)[3];
 
 	struct SiS_MCLKData const *MCLKData;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index a1be751..b7abe25 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -33,18 +33,18 @@ const struct XGI_ECLKDataStruct XGI340_ECLKData[] = {
 	{0x5c, 0x23, 0x01, 166}
 };
 
-static const unsigned char XG27_SR13[4][8] = {
-	{0x35, 0x45, 0xb1, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR13 */
-	{0x41, 0x51, 0x5c, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR14 */
-	{0x32, 0x32, 0x42, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR18 */
-	{0x03, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}  /* SR1B */
-};
-
-static const unsigned char XGI340_SR13[4][8] = {
-	{0x35, 0x45, 0xb1, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR13 */
-	{0x41, 0x51, 0x5c, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR14 */
-	{0x31, 0x42, 0x42, 0x00, 0x00, 0x00, 0x00, 0x00}, /* SR18 */
-	{0x03, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00}  /* SR1B */
+static const unsigned char XG27_SR13[4][3] = {
+	{0x35, 0x45, 0xb1}, /* SR13 */
+	{0x41, 0x51, 0x5c}, /* SR14 */
+	{0x32, 0x32, 0x42}, /* SR18 */
+	{0x03, 0x03, 0x03}  /* SR1B */
+};
+
+static const unsigned char XGI340_SR13[4][3] = {
+	{0x35, 0x45, 0xb1}, /* SR13 */
+	{0x41, 0x51, 0x5c}, /* SR14 */
+	{0x31, 0x42, 0x42}, /* SR18 */
+	{0x03, 0x03, 0x03}  /* SR1B */
 };
 
 static const unsigned char XGI340_cr41[24][3] = {
-- 
1.7.8.6

